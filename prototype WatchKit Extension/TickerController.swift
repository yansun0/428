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
    var canvasSize = CGSizeZero
    
    var timeout : NSTimer?
    var ticker : NSTimer?
    var scrollRate : CGFloat = 0.0
    
    var text : String = ""
    var textAttrs : [ String : AnyObject ] = [ String : AnyObject ]()
    var textOffset = CGPointZero
    
    
    override func awakeWithContext( context : AnyObject? ) {
        super.awakeWithContext( context )
        
        let fps : CGFloat = 24.0
        let textHeight : CGFloat = 21.0; // see paragraphAttrs.maximumLineHeight in InterfaceController.swift

        self.canvasSize = WKInterfaceDevice.currentDevice().screenBounds.size
        self.textOffset.y = self.canvasSize.height / 2 - textHeight
        self.textOffset.x = 2 * self.canvasSize.width / 3
        
        if let data = context as? [ String : AnyObject ] {
            if let text = data[ "text" ] as? String,
                   attrs = data[ "attrs" ] as? [ String : AnyObject ],
                   time = data[ "duration" ] as? Int {
                    
                self.text = text
                self.textAttrs = attrs
                self.scrollRate = self.getScrollRate( fps, totalTime : time,  textHeight : textHeight )
                self.canvas.setImage( self.render() )
                    
                // ticker timer
                self.ticker = NSTimer.scheduledTimerWithTimeInterval(
                    NSTimeInterval.init( 1 / fps ),
                    target : self, selector : "tick",
                    userInfo : nil, repeats : true )
                    
                // end timer
                self.timeout = NSTimer.scheduledTimerWithTimeInterval(
                    NSTimeInterval.init( time ),
                    target : self, selector : "end",
                    userInfo : nil, repeats : true )

            }
        }
    }
    
    // returns scroll rate in px/frame
    func getScrollRate( fps : CGFloat, totalTime : Int, textHeight : CGFloat ) -> CGFloat {
        let maxSize : CGSize = CGSizeMake(3000.0, textHeight) // no way it's longer the 3000px

        let options : NSStringDrawingOptions = [NSStringDrawingOptions.UsesLineFragmentOrigin, NSStringDrawingOptions.TruncatesLastVisibleLine]
        let textSize : CGRect = self.text.boundingRectWithSize( maxSize, options : options, attributes : self.textAttrs, context : nil )
        let width = textSize.width + self.canvasSize.width // let it scroll off the screen
        
        return width / ( CGFloat( totalTime ) * fps )
    }

    
    func render() -> UIImage {
        UIGraphicsBeginImageContextWithOptions( self.canvasSize, false, 0 )
        self.text.drawAtPoint( textOffset, withAttributes: self.textAttrs )
        let result : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    
    func tick() {
        self.textOffset.x = self.textOffset.x - self.scrollRate
        self.canvas.setImage( self.render() )
    }
    
    
    func end() {
        self.popController()
        self.ticker?.invalidate()
        self.timeout?.invalidate()
    }
    

}