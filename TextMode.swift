//
//  TextMode.swift
//  prototype
//
//  Created by Yan Sun on 4 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

let IS_DEV : Bool = false
let TRIAL_TIME : Int = 10
let MESSAGE_TRIAL_TEXT = "text"
let MESSAGE_TRIAL_MODE = "mode"
let MESSAGE_TRIAL_NUM = "num"
let MESSAGE_TRIAL_STATE = "message"
let MESSAGE_TRIAL_STATE_STARTED = "started"
let MESSAGE_TRIAL_STATE_FINISHED = "finished"
let TRIALS_PER_GROUP = 20
let TRIAL_GROUP_TEXTS : [ Int : [ String ] ] =
    [ 0 : [ "The birch canoe slid on the smooth planks.",
            "Glue the sheet to the dark blue background.",
            "It's easy to tell the depth of a well.",
            "These days a chicken leg is a rare dish.",
            "Rice is often served in round bowls.",
            "The juice of lemons makes fine punch.",
            "The box was thrown beside the parked truck.",
            "The hogs were fed chopped corn and garbage.",
            "Four hours of steady work faced us. ",
            "A large size in stockings is hard to sell.",
            "The birch canoe slid on the smooth planks.",
            "Glue the sheet to the dark blue background.",
            "It's easy to tell the depth of a well.",
            "These days a chicken leg is a rare dish.",
            "Rice is often served in round bowls.",
            "The juice of lemons makes fine punch.",
            "The box was thrown beside the parked truck.",
            "The hogs were fed chopped corn and garbage.",
            "Four hours of steady work faced us. ",
            "A large size in stockings is hard to sell." ],
      1 : [ "The birch canoe slid on the smooth planks.",
            "Glue the sheet to the dark blue background.",
            "It's easy to tell the depth of a well.",
            "These days a chicken leg is a rare dish.",
            "Rice is often served in round bowls.",
            "The juice of lemons makes fine punch.",
            "The box was thrown beside the parked truck.",
            "The hogs were fed chopped corn and garbage.",
            "Four hours of steady work faced us. ",
            "A large size in stockings is hard to sell.",
            "The birch canoe slid on the smooth planks.",
            "Glue the sheet to the dark blue background.",
            "It's easy to tell the depth of a well.",
            "These days a chicken leg is a rare dish.",
            "Rice is often served in round bowls.",
            "The juice of lemons makes fine punch.",
            "The box was thrown beside the parked truck.",
            "The hogs were fed chopped corn and garbage.",
            "Four hours of steady work faced us. ",
            "A large size in stockings is hard to sell." ],
      2 : [ "The birch canoe slid on the smooth planks.",
            "Glue the sheet to the dark blue background.",
            "It's easy to tell the depth of a well.",
            "These days a chicken leg is a rare dish.",
            "Rice is often served in round bowls.",
            "The juice of lemons makes fine punch.",
            "The box was thrown beside the parked truck.",
            "The hogs were fed chopped corn and garbage.",
            "Four hours of steady work faced us. ",
            "A large size in stockings is hard to sell.",
            "The birch canoe slid on the smooth planks.",
            "Glue the sheet to the dark blue background.",
            "It's easy to tell the depth of a well.",
            "These days a chicken leg is a rare dish.",
            "Rice is often served in round bowls.",
            "The juice of lemons makes fine punch.",
            "The box was thrown beside the parked truck.",
            "The hogs were fed chopped corn and garbage.",
            "Four hours of steady work faced us. ",
            "A large size in stockings is hard to sell." ]
    ]
let TRIAL_GROUP_MODES : [ Int : [ TextMode ] ] =
    [ 0 : [ .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker,
            .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker],
      1 : [ .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP,
            .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP],
      2 : [ .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll,
            .Ticker, .RSVP, .Scroll, .Ticker, .RSVP, .Scroll]
    ]

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
            case .Ticker, .RSVP: return "canvas-controller"
        }
    }
    
    // in seconds
    var duration : NSTimeInterval {
        return NSTimeInterval.init( TRIAL_TIME - ( self == .Scroll ? 0 : 1 ) )
    }
    
    var fontSize : CGFloat {
        return 20.0
    }
    
    var lineHeight : CGFloat {
        switch self {
            case .Scroll : return self.fontSize + 1.0
            case .Ticker, .RSVP : return self.fontSize
        }
    }
    
    var attributes : [ String : AnyObject ] {
        let paragraphAttrs = NSMutableParagraphStyle.init()
        paragraphAttrs.setParagraphStyle( NSParagraphStyle.defaultParagraphStyle() )
        paragraphAttrs.lineSpacing = self.lineHeight - self.fontSize
        paragraphAttrs.maximumLineHeight = self.lineHeight
        
        return [
            NSFontAttributeName : UIFont.systemFontOfSize( self.fontSize ),
            NSParagraphStyleAttributeName : paragraphAttrs,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSBackgroundColorAttributeName : UIColor.blackColor()
        ]
    }
}


func TextModeToString( mode : TextMode ) -> String {
    return mode.description
}


func StringToTextMode( descript : String ) -> TextMode {
    switch descript {
        case TextMode.Ticker.description : return TextMode.Ticker
        case TextMode.RSVP.description : return TextMode.RSVP
        default : return TextMode.Scroll
    }
}