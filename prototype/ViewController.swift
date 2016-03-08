//
//  ViewController.swift
//  prototype
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import UIKit
import WatchConnectivity


class ViewController: UIViewController, WCSessionDelegate {
    
    let groups : [ Int : [ String ] ] =
        [ 0 : [ "The birch canoe slid on the smooth planks.",
                "Glue the sheet to the dark blue background.",
                "It's easy to tell the depth of a well.",
                "These days a chicken leg is a rare dish.",
                "Rice is often served in round bowls.",
                "The juice of lemons makes fine punch.",
                "The box was thrown beside the parked truck.",
                "The hogs were fed chopped corn and garbage.",
                "Four hours of steady work faced us. ",
                "A large size in stockings is hard to sell." ],
          1 : [ "The birch canoe slid on the smooth planks.",
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
                "A large size in stockings is hard to sell." ]
        ]
    var group : Int = 0
    var mode : TextMode = TextMode.RSVP
    var trial : Int = -1

    var session: WCSession!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sendToWatchBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (WCSession.isSupported()) {
            self.session = WCSession.defaultSession()
            self.session.delegate = self;
            self.session.activateSession()
        }
    }
    
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        self.group = segmentedControl.selectedSegmentIndex
    }
    
    
    @IBAction func sendToWatchBtnTapped( sender : UIButton! ) {
        // find the next trial params
        let text : String = self.groups[ group ]![ self.trial ]
        let message = [
            MESSAGE_TRIAL_MODE : TextModeToString( self.mode ) as AnyObject,
            MESSAGE_TRIAL_TEXT : text as AnyObject,
            MESSAGE_TRIAL_NUM : self.trial as AnyObject ]
        
        // Check the reachablity
        if !self.session.reachable {
            let alert = UIAlertController(
                title : "Failed to send",
                message : "Apple Watch is not reachable.",
                preferredStyle : UIAlertControllerStyle.Alert )
            let okAction = UIAlertAction(
                title : "OK",
                style : UIAlertActionStyle.Cancel,
                handler : nil)
            alert.addAction( okAction )
            presentViewController( alert, animated : true, completion : nil )

        } else {
            self.session.sendMessage( message, replyHandler : nil, errorHandler: nil )
        }
    }
    
    
    func session( session : WCSession,
        didReceiveMessage message : [ String : AnyObject ],
        replyHandler : ( [ String : AnyObject ] ) -> Void ) {
            if let msg = message[ MESSAGE_TRIAL ] as? String {
                if ( msg == MESSAGE_TRIAL_STARTED ) {
                    self.sendToWatchBtn.enabled = false
                } else if ( msg == MESSAGE_TRIAL_FINISHED ) {
                    self.sendToWatchBtn.enabled = true
                    
                    // handle redo a trial here
                    
                    // handle move onto to next trial here
                    self.trial = self.trial + 1
                    
                    // handle trial completion here
                }
            }
    }
    
}

