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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageCell: UIView!
    
    var messages = [PFObject]()
    
    func onTimer() {
        let query = PFQuery(className:"Message_iOSFeb2016")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                print("Successfully retrieved \(objects!.count) messages.")
                // Do something with the found objects
                if let objects = objects {
                    self.messages = objects
                    self.tableView.reloadData()
                }
            } else {
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: "onTimer", userInfo: nil, repeats: true)
    }

}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
        // set text
        let message = messages[indexPath.row] as PFObject
        cell.messageCell.text = message["text"] as? String
        return cell
    }
}
