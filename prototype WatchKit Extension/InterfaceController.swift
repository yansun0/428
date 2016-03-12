//
//  InterfaceController.swift
//  prototype WatchKit Extension
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController : WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var button: WKInterfaceButton!
    @IBOutlet var message: WKInterfaceLabel!

    
    var trialMode : TextMode? // trial constants should be sent from the ios app
    var trialData : [ String : AnyObject ] = [ String : AnyObject ]()
    var didTrialRan : Bool = false
    
    
    override func awakeWithContext( context : AnyObject? ) {
        super.awakeWithContext( context )
        
        if WCSession.isSupported() {
            let session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        // for dev purposes only -- these stuff should be async set from ios ap
        if IS_DEV {
            let devMode = TextMode.Ticker
            let devStr : String = "Today I Learned that the Higgs boson, commonly refered to as the God Particle, was originally intended to be name the goddamn particle, but Leon Lederman's publisher asked that it be changed."
            let devTrialNum = 5
            self.setupTrial( devMode, trialText: devStr, trialNum: devTrialNum )
        
        } else {
            self.setButtonState( false, trial : nil, mode : nil )
        }
    }
    
    
    override func willActivate() {
        super.willActivate()
        if self.didTrialRan {
            self.setButtonState( false, trial : nil, mode : nil )
            self.didTrialRan = false
            let session = WCSession.defaultSession()
            let message = [ MESSAGE_TRIAL_STATE : MESSAGE_TRIAL_STATE_FINISHED as AnyObject ]
            do {
                try session.updateApplicationContext( message )
            } catch {
            }
        }
    }

    
    override func didDeactivate() {
        super.didDeactivate()
        self.didTrialRan = true
    }

    
    // Received message from iPhone
    func session( session: WCSession,
                  didReceiveApplicationContext message: [String : AnyObject]) {
        print(__FUNCTION__)
        if let text = message[ MESSAGE_TRIAL_TEXT ] as? String,
            mode = message[ MESSAGE_TRIAL_MODE ] as? String,
            num = message[ MESSAGE_TRIAL_NUM ] as? Int {
                self.setupTrial( StringToTextMode( mode ), trialText : text, trialNum: num + 1 )
        }
    }

    func session( session : WCSession,
                  didReceiveMessage message : [ String : AnyObject ],
                  replyHandler : ( [ String : AnyObject ] ) -> Void ) {
        print(__FUNCTION__)
        if let text = message[ MESSAGE_TRIAL_TEXT ] as? String,
               mode = message[ MESSAGE_TRIAL_MODE ] as? String,
               num = message[ MESSAGE_TRIAL_NUM ] as? Int {
            self.setupTrial( StringToTextMode( mode ), trialText : text, trialNum: num )
        }
    }
    

    @IBAction func StartButton() {
        if let mode = self.trialMode {
            pushControllerWithName( mode.controllerName, context : self.trialData )
            let session = WCSession.defaultSession()
            let message = [ MESSAGE_TRIAL_STATE : MESSAGE_TRIAL_STATE_STARTED as AnyObject ]
            do {
                try session.updateApplicationContext( message )
            } catch {
            }
            self.didTrialRan = true
        }
    }
    
    
    func setButtonState( isEnabled : Bool, trial : Int?, mode : String? ) {
        self.button.setEnabled( isEnabled )
        if isEnabled {
            if let trialNum = trial, modeText = mode {
                self.message.setText( String( format: "trial: %d\nmode: %@", trialNum, modeText ) )
            }
        } else {
            self.message.setText( "Please wait for the next trial to start." )
        }
    }
    
    
    // prepares the trial before the start button is pressed so to reduce wait time
    func setupTrial( mode : TextMode, trialText : String, trialNum : Int ) {
        self.trialMode = mode
        var data : [ String : AnyObject ] = [ "duration" : mode.duration ]
        switch mode {
            case TextMode.Ticker, TextMode.RSVP:
                let renderedResult = self.render( mode, text : trialText );
                data[ "img" ] = renderedResult.image
                data[ "frameCount" ] = renderedResult.frameCount
                data[ "time" ] = mode.duration + NSTimeInterval.init( 0.5 )
                break;
            case TextMode.Scroll:
                data[ "text" ] = trialText
                data[ "attrs" ] = mode.attributes
                break;
        }
        self.trialData = data
        self.setButtonState( true, trial : trialNum, mode : mode.description )
    }
    
    
    func render( mode : TextMode, text: String ) -> ( image : UIImage?, frameCount : Int ) {
        // rendering constants
        let fps : CGFloat = 30.0
        let canvasHeightScale : CGFloat = 0.2
        var canvasSize : CGSize = WKInterfaceDevice.currentDevice().screenBounds.size
        canvasSize.height = canvasSize.height * canvasHeightScale
        return ( mode == TextMode.Ticker ) ?
            self.renderTicker( mode, text: text, fps : fps, canvasSize : canvasSize ) :
            self.renderRSVP( mode, text: text, fps : fps, canvasSize : canvasSize )
    }
    
    
    // do the rendering here BEFORE transitioning to reduce loading time AFTER transition
    func renderTicker( mode : TextMode, text : String, fps : CGFloat, canvasSize : CGSize ) -> ( image : UIImage?, frameCount : Int ) {
        var textOffset : CGPoint = CGPointMake( canvasSize.width / 2, ( canvasSize.height - mode.fontSize ) / 2 )
        let totalFrames : Int = Int( round( fps * CGFloat( mode.duration ) ) )
        var frames = [ UIImage ]()
        
        // get the scroll rate in pixels per frame
        let maxSize : CGSize = CGSizeMake( 3000.0, mode.fontSize ) // no way it's longer the 3000px
        let options : NSStringDrawingOptions = [
            NSStringDrawingOptions.UsesLineFragmentOrigin,
            NSStringDrawingOptions.TruncatesLastVisibleLine ]
        let textSize : CGRect = text.boundingRectWithSize( maxSize, options : options, attributes : mode.attributes, context : nil )
        let width = textSize.width + canvasSize.width / 2 // let it scroll off the screen
        let scrollRate = width / ( CGFloat( mode.duration ) * fps )
        
        for _ in 1...totalFrames {
            textOffset.x = textOffset.x - scrollRate
            frames.append( self.renderFrame( text, textAttrs : mode.attributes, offset : textOffset, canvasSize : canvasSize ) )
        }
        
        return ( UIImage.animatedImageWithImages( frames, duration: mode.duration ), totalFrames )
    }
    
    
    func renderRSVP( mode : TextMode, text : String, fps : CGFloat, canvasSize : CGSize ) -> ( image : UIImage?, frameCount : Int ) {
        let words : [String] = text.componentsSeparatedByCharactersInSet( NSCharacterSet.whitespaceAndNewlineCharacterSet() )
        let totalFrames : Int = words.count
        var frames = [ UIImage ]()
        
        let maxSize : CGSize = CGSizeMake( canvasSize.width, mode.fontSize ) // assume words are not gonna be longer than screen
        let strOpts : NSStringDrawingOptions = [
            NSStringDrawingOptions.UsesLineFragmentOrigin,
            NSStringDrawingOptions.TruncatesLastVisibleLine ]
        var word : String = ""
        var wordOffset : CGPoint = CGPointZero
        
        for i in 0..<totalFrames {
            word = words[ i ]
            let wordSize : CGRect = word.boundingRectWithSize( maxSize, options : strOpts, attributes : mode.attributes, context : nil )
            wordOffset = CGPointMake( ( canvasSize.width - wordSize.width ) / 2, ( canvasSize.height - wordSize.height ) / 2 )
            frames.append( self.renderFrame( word, textAttrs : mode.attributes, offset : wordOffset, canvasSize : canvasSize ) )
        }

        return ( UIImage.animatedImageWithImages( frames, duration: mode.duration ), totalFrames )
    }

    
    func renderFrame( text : String, textAttrs : [ String : AnyObject ], offset : CGPoint, canvasSize : CGSize ) -> UIImage {
        UIGraphicsBeginImageContextWithOptions( canvasSize, false, 0 )
        text.drawAtPoint( offset, withAttributes: textAttrs )
        let result : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    
    
}
