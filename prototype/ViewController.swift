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
    
    var group : Int = 0
    var mode : TextMode = TextMode.RSVP
    var trial : Int = 0
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var sendToWatchBtn: UIButton!
    @IBOutlet weak var resetStudyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (WCSession.isSupported()) {
            let session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
    }
    
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        self.group = segmentedControl.selectedSegmentIndex
    }
    
    
    @IBAction func resetStudyAction(sender: AnyObject) {
        self.resetStudy()
    }
    
    
    func resetStudy() {
        self.trial = 0
        self.sendToWatchBtn.enabled = true
    }
    
    
    @IBAction func sendToWatchBtnTapped( sender : UIButton! ) {
        self.sendMessageToWatch()
        self.sendToWatchBtn.enabled = false
    }
    

    func sendMessageToWatch() {
        // find the next trial params
        
        let text : String = TRIAL_GROUP_TEXTS[ group ]![ self.trial ]
        let message = [
            MESSAGE_TRIAL_MODE : TextModeToString( TRIAL_GROUP_MODES [ group ]![ self.trial ] ) as AnyObject,
            MESSAGE_TRIAL_TEXT : text as AnyObject,
            MESSAGE_TRIAL_NUM : self.trial as AnyObject ]
        
        // Check the reachablity
        let session = WCSession.defaultSession()
        do {
            try session.updateApplicationContext( message )
        } catch {
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
        }
    }
    
    
    func session( session : WCSession,
                  didReceiveApplicationContext message : [ String : AnyObject ] ) {

        if let msg = message[ MESSAGE_TRIAL_STATE ] as? String {
            if ( msg == MESSAGE_TRIAL_STATE_STARTED ) {
                self.sendToWatchBtn.enabled = false
                
            } else if ( msg == MESSAGE_TRIAL_STATE_FINISHED ) {
                self.sendToWatchBtn.enabled = true
                
                let refreshAlert = UIAlertController(
                    title : "Complete",
                    message : String( format: "User compeleted trial %d of %d", self.trial + 1, TRIALS_PER_GROUP ),
                    preferredStyle : UIAlertControllerStyle.Alert )

                let alertActionNext = UIAlertAction(
                    title : ( ( self.trial < TRIALS_PER_GROUP ) ? "Next Trial" : "End Study" ),
                    style: .Default,
                    handler: { ( action: UIAlertAction! ) in
                        self.trial = self.trial + 1
                        if (self.trial < TRIALS_PER_GROUP) {
                            self.sendMessageToWatch() // next trial
                        } else {
                            self.resetStudy()         // trials done
                        }
                } )
                refreshAlert.addAction(alertActionNext)

                let alertActionRedo = UIAlertAction(
                    title : "Redo Trial",
                    style: .Default,
                    handler: { ( action: UIAlertAction! ) in
                        self.sendMessageToWatch()
                } )
                refreshAlert.addAction(alertActionRedo)
                
                presentViewController(refreshAlert, animated: true, completion: nil)
            }
        }
    
    }

    
}

