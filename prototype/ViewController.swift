//
//  ViewController.swift
//  prototype
//
//  Created by Yan Sun on 1 Mar 16.
//  Copyright © 2016 Yan Sun. All rights reserved.
//

import UIKit
import WatchConnectivity


class ViewController: UIViewController {
    
    var groups:[Int:[String]] = [0:
        ["The birch canoe slid on the smooth planks.",
        "Glue the sheet to the dark blue background.",
        "It's easy to tell the depth of a well.",
        "These days a chicken leg is a rare dish.",
        "Rice is often served in round bowls.",
        "The juice of lemons makes fine punch.",
        "The box was thrown beside the parked truck.",
        "The hogs were fed chopped corn and garbage.",
        "Four hours of steady work faced us. ",
        "A large size in stockings is hard to sell."],
        
        1:
        ["The birch canoe slid on the smooth planks.",
        "Glue the sheet to the dark blue background.",
        "It's easy to tell the depth of a well.",
        "These days a chicken leg is a rare dish.",
        "Rice is often served in round bowls.",
        "The juice of lemons makes fine punch.",
        "The box was thrown beside the parked truck.",
        "The hogs were fed chopped corn and garbage.",
        "Four hours of steady work faced us. ",
        "A large size in stockings is hard to sell."],
        
        2:
        ["The birch canoe slid on the smooth planks.",
        "Glue the sheet to the dark blue background.",
        "It's easy to tell the depth of a well.",
        "These days a chicken leg is a rare dish.",
        "Rice is often served in round bowls.",
        "The juice of lemons makes fine punch.",
        "The box was thrown beside the parked truck.",
        "The hogs were fed chopped corn and garbage.",
        "Four hours of steady work faced us. ",
        "A large size in stockings is hard to sell."]
    ]
    
    var index:Int = 0;
    

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func segmentedControlAction(sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0) {
            self.index = 0
        }
        else if(segmentedControl.selectedSegmentIndex == 1) {
            self.index = 1
        }
        else if(segmentedControl.selectedSegmentIndex == 2) {
            self.index = 2
        }
    }
    
    
    @IBAction func sendToWatchBtnTapped(sender: UIButton!) {
        
        // Check the reachablity
        if !WCSession.defaultSession().reachable {
            
            let alert = UIAlertController(
                title: "Failed to send",
                message: "Apple Watch is not reachable.",
                preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Cancel,
                handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let message = ["request": "showAlert"]
        WCSession.defaultSession().sendMessage(
            message, replyHandler: { (replyMessage) -> Void in
                //
            }) { (error) -> Void in
                print(error)
        }
    }
    
    

}

