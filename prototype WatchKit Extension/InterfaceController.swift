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

    enum TextMode {
        case Scroll
        case Ticker
        case RSVP
        
        var description : String {
            switch self {
                case .Scroll: return "Scroll"
                case .Ticker: return "Ticker"
                case .RSVP: return "RSVP"
            }
        }
        
        var controllerName : String {
            switch self {
                case .Scroll: return "scroll-controller"
                case .Ticker: return "ticker-controller"
                case .RSVP: return "rsvp-controller"
            }
        }
    }
    var curMode : TextMode = TextMode.Ticker
    var curText : String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi sed eleifend diam, at tincidunt augue. Duis tincidunt dui ut accumsan facilisis. Nunc sit amet diam suscipit, commodo mauris eu, commodo augue."
    var timeLimit : Int = 15 // seconds
    var trialReady : Bool = true // represents when interface is true


    override func willActivate() {
        super.willActivate()
        // when returning from a trial, disable the button until the next trail sent from the iphone
//        if self.trialReady {
//            self.trialReady = false
//        }
//        self.toggleReadyState( self.trialReady, trial : nil, mode: nil )
        self.toggleReadyState( self.trialReady, trial : 5, mode: self.curMode )
    }

    func toggleReadyState( isReady : Bool, trial : Int?, mode : TextMode? ) {
        self.button.setEnabled( isReady )
        if isReady {
            if let trialNum = trial, modeText = mode {
                self.message.setText(String(format: "trial: %d\nmode: %@", trialNum, modeText.description))
             }
        } else {
            self.message.setText("Please wait for the next trial to start.")
        }
    }
    

    @IBAction func StartButton() {
        let paragraphAttrs = NSMutableParagraphStyle.init()
        paragraphAttrs.setParagraphStyle( NSParagraphStyle.defaultParagraphStyle() )
        paragraphAttrs.maximumLineHeight = 21.0
        
        let attrs : [ String : AnyObject ] = [
            NSFontAttributeName : UIFont.systemFontOfSize( 20.0 ),
            NSParagraphStyleAttributeName : paragraphAttrs,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSBackgroundColorAttributeName : UIColor.blackColor()
        ]
        
        let data : [ String : AnyObject ] = [ "text" : self.curText, "attrs" : attrs, "duration" : self.timeLimit ]

        pushControllerWithName( self.curMode.controllerName, context : data )
    }
    
}
