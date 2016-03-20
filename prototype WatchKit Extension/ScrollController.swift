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
        
        if let data = context as? [ String : AnyObject ],
               text = data[ "text" ] as? String,
               attrs = data[ "attrs"] as? [ String : AnyObject ],
               time = data[ "duration" ] as? NSTimeInterval {
                
            let attrText = NSAttributedString.init( string : text, attributes : attrs )
            self.label.setAttributedText( attrText )

            self.timeout = NSTimer.scheduledTimerWithTimeInterval( time,
                target : self, selector : "end",
                userInfo : nil, repeats : true )
        }
    }
    
    func end() {
        self.label.setHidden( true )
        self.timeout?.invalidate()
        
        // add half second delay transitioning
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC/2)),
            dispatch_get_main_queue(),
            {
                self.popController()
            }
        )
    }

}