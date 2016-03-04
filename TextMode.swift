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

let TRIAL_TIME : Int = 5

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
