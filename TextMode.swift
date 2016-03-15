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
let MESSAGE_TRIAL_STATE_CANCEL = "cancel"
let TRIALS_PER_GROUP = 20
let TRIAL_GROUP_TEXTS : [ Int : [ String ] ] =
    [ 0 : [ "President Obama and Prime Minister Trudeau promised to make it easier for their countries to trade, invest in one another, and promote clean energy.",
            "California lawmakers voted to raise the smoking age from 18 to 21, it is the second state to restrict teenagers from buying tobacco products.",
            "The federal government is proposing new privacy rules that would make Internet providers ask your permission before using and sharing your data.",
            "The human Go champion was left speechless after his second straight loss to Google's Go-playing machine in a five game human versus machine face-off.",
            "Apple announced it will hold its spring product launch on March 21, with an invitation sent to reporters on said only 'Let us loop you in.'",
            "A 93-year-old Ohio woman has received the high school diploma she was denied because of rules that expelled married students.",
            "Five Thai fishing boat captains were sentenced to three years in jail for human trafficking in connection with slavery in the seafood industry.",
            "Members of the public filed past Nancy Reagan's coffin to pay their respects before the Reagan Library is closed to prepare for her funeral.",
            "An Atlanta small insurance company require employees to carry firearms at the office has sparked a debate on gun safety in the workplace.",
            "Google is previewing the next version of Android two months ahead of schedule in an effort to get the upgraded software on more mobile devices.",
            "Newly released video shows the moment a Google self-driving car struck the side of a public bus in the Silicon Valley city of Mountain View.",
            "A would-be robber in Pennsylvania had some pretty poor timing when he pulled a gun on his taxi driver with a sheriff's deputy behind him.",
            "Out of the 8670 noise complaints Washington's Reagan National Airport received last year, officials say a whopping 6500 of them came from the same person.",
            "A Virginia jail is no longer allowing inmates to receive photographs after officials found inmates chewing on pictures that had been soaked in a drug.",
            "President Obama signaled that his announcement of a Supreme Court nominee could come soon, saying the court needs to operate at full strength.",
            "Louisiana residents are taking stock of damages after a massive rain submerged roads, washed out bridges, and forced residents to flee homes.",
            "Many women say video games such as 'World of Warcraft' are rife with harassment, stalking and sexism that game companies don't police effectively.",
            "An Orange County defense attorney suffered a bloodied face and fractured nose after a brawl with a district attorney's investigator in a courthouse.",
            "General Motors has acquired the small software company Cruise Automation that's been testing self-driving vehicles on the streets of San Francisco.",
            "President Obama sided with law enforcement on the debate of privacy versus national security, saying that data on electronic devices must be accessible." ],
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