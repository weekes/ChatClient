//
//  ChatViewController.swift
//  ChatClient
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {
    @IBOutlet weak var messageField: UITextField!

    @IBAction func postMessage(sender: UIButton) {
        let messageText = messageField.text
        let message = PFObject(className:"Message_iOSFeb2016")
        message["text"] = messageText
        
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // happy path
                NSLog("message sent")
                self.messageField.text = ""
            } else {
                // error case
                NSLog("message failed to send")
            }
        }
    }
}
