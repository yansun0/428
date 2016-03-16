//
//  CanvasController.swift
//  prototype
//
//  Created by Yan Sun on 4 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import WatchKit
import Foundation

class CanvasController : WKInterfaceController {
    
    @IBOutlet var canvas: WKInterfaceImage!
    
    var ran = false
    var timeout : NSTimer?
    var duration : NSTimeInterval?
    var frameCount : Int?
    
    override func awakeWithContext( context : AnyObject? ) {
        super.awakeWithContext( context )
        
        if let data = context as? [ String : AnyObject ],
            img = data[ "img" ] as? UIImage,
            count = data[ "frameCount" ] as? Int,
            dur = data[ "duration" ] as? NSTimeInterval {
                self.canvas.setImage( img )
                self.duration = dur
                self.frameCount = count
        }
    }
    

    override func willActivate() {
        super.willActivate()
        
        if let count = self.frameCount, dur = self.duration where self.ran == false{
            let imageRange : NSRange = NSRange.init( 0 ... ( count - 1 ) )
            // add half second delay before animating so that user can have a moment to focus on the text location
            dispatch_after(
                dispatch_time( DISPATCH_TIME_NOW, Int64( NSEC_PER_SEC / 4 ) ),
                dispatch_get_main_queue(),
                {
                    self.canvas.startAnimatingWithImagesInRange( imageRange, duration: dur, repeatCount : 1 )
                    self.ran = true
                    // end timer
//                    self.timeout = NSTimer.scheduledTimerWithTimeInterval( dur,
//                        target : self, selector : "end",
//                        userInfo : nil, repeats : true )
                }
            )
        }
    }
    
    
//    func end() {
//        self.canvas.stopAnimating()
//        self.timeout?.invalidate()
//
//        // add half second delay transitioning
//        dispatch_after(
//            dispatch_time(DISPATCH_TIME_NOW, Int64(NSEC_PER_SEC/2)),
//            dispatch_get_main_queue(),
//            {
//                self.popController()
//            }
//        )
//    }
    
}