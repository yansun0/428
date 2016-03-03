//
//  RSVPController.swift
//  prototype
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import WatchKit
import Foundation

class RSVPController: WKInterfaceController {
    
    override func awakeWithContext( context : AnyObject? ) {
        super.awakeWithContext( context )
        if let data = context as? Dictionary< String, AnyObject > {
            if let text = data[ "text" ] as? String {
                NSLog( text )
            }
            if let time = data[ "duration" ] as? Int {
                NSLog( "%d", time )
            }
        }
    }

}