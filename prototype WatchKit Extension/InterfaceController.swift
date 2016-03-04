//
//  InterfaceController.swift
//  prototype WatchKit Extension
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController : WKInterfaceController {
    
    @IBOutlet var button: WKInterfaceButton!
    @IBOutlet var message: WKInterfaceLabel!

    // rendering constants
    let fps : CGFloat = 30.0
    var canvasSize : CGSize = CGSizeZero
    var canvasHeightScale : CGFloat = 0.2
    
    // trial constants
    var mode : TextMode = TextMode.Ticker
    var text : String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sed eleifend diam, at tincidunt augue. Duis tincidunt dui ut accumsan facilisis. Nunc sit amet diam suscipit, commodo mauris eu, commodo augue."
    var duration : NSTimeInterval = NSTimeInterval.init( 15 ) // in seconds
    var trialReady : Bool = true                              // represents when interface is true
    
    
    override func awakeWithContext( context : AnyObject? ) {
        super.awakeWithContext( context )
        self.canvasSize = WKInterfaceDevice.currentDevice().screenBounds.size
        self.canvasSize.height = self.canvasSize.height * self.canvasHeightScale
    }
    

    override func willActivate() {
        super.willActivate()
        // when returning from a trial, disable the button until the next trail sent from the iphone
//        if self.trialReady {
//            self.trialReady = false
//        }
//        self.toggleReadyState( self.trialReady, trial : nil, mode: nil )
        self.toggleReadyState( self.trialReady, trial : 5, mode: self.mode )
    }

    
    func toggleReadyState( isReady : Bool, trial : Int?, mode : TextMode? ) {
        self.button.setEnabled( isReady )
        if isReady {
            if let trialNum = trial, modeText = mode {
                self.message.setText( String( format: "trial: %d\nmode: %@", trialNum, modeText.description ) )
             }
        } else {
            self.message.setText( "Please wait for the next trial to start." )
        }
    }
    

    @IBAction func StartButton() {
        
        var data : [ String : AnyObject ] = [ "duration" : self.duration ]
        switch self.mode {
            case TextMode.Ticker:
                let renderedResult = self.renderTicker(self.text, textAttrs : mode.attributes, textHeight : mode.fontSize,
                                                       canvasSize : self.canvasSize, fps: self.fps,totalTime : self.duration )
                data[ "img" ] = renderedResult.image
                data[ "frameCount" ] = renderedResult.frameCount
                break;
                
            case TextMode.Scroll:
                data[ "text" ] = self.text
                data[ "attrs" ] = mode.attributes
                break;
            
            case TextMode.RSVP:
                // TODO
                break;
        }
        
        pushControllerWithName( self.mode.controllerName, context : data )
    }
    
    
    // render it here to reduce loading time after transition
    func renderTicker( text : String, textAttrs : [ String : AnyObject ], textHeight : CGFloat,
                       canvasSize : CGSize, fps : CGFloat, totalTime : NSTimeInterval
                     ) -> ( image : UIImage?, frameCount : Int ) {
                        
        var textOffset = CGPointMake( 2 * canvasSize.width / 3, canvasSize.height / 2 - textHeight )
        let totalFrames : Int = Int( round( fps * CGFloat( totalTime ) ) )
        var frames = [ UIImage ]()
        
        // get the scroll rate in pixels per frame
        let maxSize : CGSize = CGSizeMake( 3000.0, textHeight ) // no way it's longer the 3000px
        let options : NSStringDrawingOptions = [
            NSStringDrawingOptions.UsesLineFragmentOrigin,
            NSStringDrawingOptions.TruncatesLastVisibleLine ]
        let textSize : CGRect = text.boundingRectWithSize( maxSize, options : options, attributes : textAttrs, context : nil )
        let width = textSize.width + canvasSize.width * 1.5 // let it scroll off the screen
        let scrollRate = width / ( CGFloat( totalTime ) * fps )
        
        for _ in 1...totalFrames {
            textOffset.x = textOffset.x - scrollRate
            frames.append( self.renderTickerFrame( text, textAttrs : textAttrs, offset : textOffset, canvasSize : canvasSize ) )
        }
        
        return (UIImage.animatedImageWithImages( frames, duration: totalTime ), totalFrames)
    }
    
    
    func renderTickerFrame( text : String, textAttrs : [ String : AnyObject ], offset : CGPoint, canvasSize : CGSize ) -> UIImage {
        UIGraphicsBeginImageContextWithOptions( canvasSize, false, 0 )
        text.drawAtPoint( offset, withAttributes: textAttrs )
        let result : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    
}
