//
//  ViewController.swift
//  prototype
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import UIKit
import WatchConnectivity


class ViewController: UIViewController, WCSessionDelegate, UITextFieldDelegate {
    
    var group : Int = 0
    var mode : TextMode = TextMode.RSVP
    var trial : Int = 0
    
    @IBOutlet weak var trialNum: UITextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var testRunSelector: UISegmentedControl!
    @IBOutlet weak var sendToWatchBtn: UIButton!
    @IBOutlet weak var resetStudyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ( WCSession.isSupported() ) {
            let session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
        self.trialNum.delegate = self
    }

    
    // UI: keyboard
    
    override func touchesBegan( touches: Set<UITouch>, withEvent event: UIEvent? ) {
        super.touchesBegan( touches, withEvent: event )
        view.endEditing( true )
    }
    
    
    func textFieldDidEndEditing( textField: UITextField ) {
        if let textNum = textField.text {
            if let trialNum = Int( textNum ) {
                self.trial = trialNum - 1
                return
            }
        }
        textField.text = String( self.trial + 1 )
    }

    
    // UI: buttons
    
    @IBAction func sendTestToWatchBtnTapped( sender: AnyObject ) {
        let mode : TextMode = ( self.testRunSelector.selectedSegmentIndex == 0 ) ?
                                TextMode.Scroll :
                                ( ( self.testRunSelector.selectedSegmentIndex == 1 ) ?
                                    TextMode.RSVP : TextMode.Ticker )
        let msg = getTestMessageForWatch( mode )
        self.sendMessageToWatch( msg )
    }
    
    
    @IBAction func segmentedControlAction( sender: AnyObject ) {
        self.group = self.segmentedControl.selectedSegmentIndex
    }
    
    
    @IBAction func resetWatchAction(sender: AnyObject) {
        self.reset( false )
    }
    
    
    @IBAction func resetStudyAction( sender: AnyObject ) {
        self.reset( true )
    }
    
    
    func reset( trial : Bool ) {
        if trial {
            self.trial = 0
            self.trialNum.text = String( self.trial + 1 )
        }
        let msg = self.getMessageForWatch( self.group, trialNum: self.trial, isCancel: true )
        self.sendMessageToWatch( msg )
        self.sendToWatchBtn.enabled = true
    }
    
    
    @IBAction func sendToWatchBtnTapped( sender : UIButton! ) {
        let msg = self.getMessageForWatch( self.group, trialNum: self.trial, isCancel: false )
        self.sendMessageToWatch( msg )
        self.sendToWatchBtn.enabled = false
    }
    
    
    func getTimeForText( text : String ) -> Float {
        let WPM : Float = 200.0
        let numOfWords : Float = Float(text.componentsSeparatedByString(" ").count)
        let numOfChars : Float = Float(text.characters.count)
        let durationForWords : Float = ( numOfWords * 60.0 ) / WPM
        let durationForChars : Float = ( 60.0 * numOfChars ) / (WPM * 5)
        return ((durationForChars + durationForWords) / 2.0)
    }
    
    
    func getTestMessageForWatch( mode : TextMode ) -> [ String : AnyObject ] {
        return[ MESSAGE_TRIAL_MODE : TextModeToString( mode ) as AnyObject,
                MESSAGE_TRIAL_TEXT : TEST_RUN_TEXT as AnyObject,
                MESSAGE_TRIAL_DURATION : getTimeForText( TEST_RUN_TEXT ) as AnyObject,
                MESSAGE_TRIAL_TEST_RUN : true as AnyObject,
                MESSAGE_TRIAL_NUM : 0 as AnyObject ]
    }
    
    
    func getMessageForWatch( groupNum : Int,
                             trialNum : Int,
                             isCancel : Bool ) -> [ String : AnyObject ] {
        let text : String = TRIAL_TEXTS[ self.trial ]
        let mode : TextMode = TRIAL_GROUP_MODES[ self.group ]![ trialNum ]
        let message : [ String : AnyObject ] = isCancel ?
            [ MESSAGE_TRIAL_STATE : MESSAGE_TRIAL_STATE_CANCEL as AnyObject ] :
            [ MESSAGE_TRIAL_MODE : TextModeToString( mode ) as AnyObject,
              MESSAGE_TRIAL_TEXT : text as AnyObject,
              MESSAGE_TRIAL_DURATION : getTimeForText( text ) as AnyObject,
              MESSAGE_TRIAL_TEST_RUN : false as AnyObject,
              MESSAGE_TRIAL_NUM : trialNum as AnyObject ]
        return message
    }
    

    func sendMessageToWatch( message : [ String : AnyObject ] ) {
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
                
                let refreshAlert = UIAlertController(
                    title : "Complete",
                    message : String( format: "User compeleted trial %d of %d", self.trial + 1, TRIALS_TOTAL ),
                    preferredStyle : UIAlertControllerStyle.Alert )

                let alertActionOk = UIAlertAction(
                    title : "OK",
                    style: UIAlertActionStyle.Default,
                    handler: { ( action: UIAlertAction! ) in
                        self.trial = self.trial + 1
                        if self.trial < TRIALS_TOTAL {
                            self.trialNum.text = String( self.trial + 1 )
                            self.sendToWatchBtn.enabled = true
                        } else {
                            self.reset( true )
                        }
                } )
                refreshAlert.addAction(alertActionOk)
                
                let alertActionRedo = UIAlertAction(
                    title : "Redo",
                    style: UIAlertActionStyle.Destructive,
                    handler: { ( action: UIAlertAction! ) in
                        let msg = self.getMessageForWatch( self.group, trialNum: self.trial, isCancel: false )
                        self.sendMessageToWatch( msg )
                } )
                refreshAlert.addAction(alertActionRedo)
                
                presentViewController(refreshAlert, animated: true, completion: nil)
            }
        }
    
    }

    
}

