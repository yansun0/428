//
//  InterfaceController.swift
//  prototype WatchKit Extension
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    
    @IBOutlet var mode: WKInterfaceLabel!
    @IBOutlet var trial: WKInterfaceLabel!
    
    enum TextMode {
        case Scroll
        case Ticker
        case RSVP
    }
    var curMode = TextMode.Scroll
    var curText = "test test test"
    
    @IBAction func StartButton() {
        let name : String = TextModeToControllerName(curMode)
        pushControllerWithName(name, context: nil)
    }
    
    func TextModeToControllerName(mode : TextMode) -> String {
        switch mode {
            case TextMode.Scroll:
                return "scroll-controller"
            case TextMode.Ticker:
                return "ticker-controller"
            case TextMode.RSVP:
                return "rsvp-controller"
        }
    }
    
}
