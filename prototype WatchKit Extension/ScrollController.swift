//
//  ScrollController.swift
//  prototype
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import WatchKit
import Foundation

class ScrollController : WKInterfaceController {

    @IBOutlet var label : WKInterfaceLabel!
    var timeout : NSTimer?

    override func awakeWithContext( context : AnyObject? ) {
        super.awakeWithContext( context )
        
        if let data = context as? [ String : AnyObject ] {
            if let text = data[ "text" ] as? String,
                   attrs = data[ "attrs"] as? [ String : AnyObject ] {
                let attrText = NSAttributedString.init( string : text, attributes : attrs )
                label.setAttributedText( attrText )
            }
            if let time = data[ "duration" ] as? Int {
                let timeLimit = NSTimeInterval.init( time )
                self.timeout = NSTimer.scheduledTimerWithTimeInterval( timeLimit,
                    target : self, selector : "end",
                    userInfo : nil, repeats : true )
            }
        }
    }
    
    func end() {
        self.popController()
        self.timeout?.invalidate()
    }

}