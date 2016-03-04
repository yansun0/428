//
//  TickerController.swift
//  prototype
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import WatchKit
import Foundation

class TickerController: WKInterfaceController {

    @IBOutlet var canvas : WKInterfaceImage!
    
    var timeout : NSTimer?
    
    override func awakeWithContext( context : AnyObject? ) {
        super.awakeWithContext( context )
        
        if let data = context as? [ String : AnyObject ],
               img = data[ "img" ] as? UIImage,
               count = data[ "frameCount" ] as? Int,
               time = data[ "duration" ] as? NSTimeInterval {

            let imageRange : NSRange = NSRange.init( 0 ... ( count - 1 ) )
            self.canvas.setImage( img )
            self.canvas.startAnimatingWithImagesInRange( imageRange, duration : time, repeatCount : 0 )
            
            // end timer
            self.timeout = NSTimer.scheduledTimerWithTimeInterval(
                NSTimeInterval.init( time ),
                target : self, selector : "end",
                userInfo : nil, repeats : true )
        }
    }
    
    
    func end() {
        self.popController()
        self.timeout?.invalidate()
    }
    

}