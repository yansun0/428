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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    // Want to be able to select either group 1, 2, or 3
    // Have a button that lets you click start new trial which sends the list and order to
    // the apple watch
    
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

