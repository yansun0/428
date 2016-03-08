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

let TRIAL_TIME : Int = 10
let IS_DEV : Bool = true
let MESSAGE_TRIAL_TEXT = "text"
let MESSAGE_TRIAL_MODE = "mode"
let MESSAGE_TRIAL_NUM = "num"
let MESSAGE_TRIAL = "message"
let MESSAGE_TRIAL_STARTED = "started"
let MESSAGE_TRIAL_FINISHED = "finished"

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