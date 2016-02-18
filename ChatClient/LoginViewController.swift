//
//  LoginViewController.swift
//  ChatClient
//
//  Created by Marcel Weekes on 2/17/16.
//  Copyright © 2016 Marcel Weekes. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func onLoginPressed(sender: AnyObject) {
        if validateForm() {
            PFUser.logInWithUsernameInBackground(self.emailField.text!, password: self.passwordField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    self.user = user
                    print("Logged in!")
                } else {
                    self.alertController.title = "Login Error"
                    self.alertController.message = "Could not log in with given username and password."
                    self.presentViewController(self.alertController, animated: true) { }
                }
            }
        } else {
            presentViewController(alertController, animated: true) { }
        }
    }
    
    @IBAction func onSignUpPressed(sender: AnyObject) {
        if validateForm() {
            user = PFUser()
            if let user = user {
                user.username = self.emailField.text
                user.email = self.emailField.text
                user.password = self.passwordField.text
            
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if let error = error {
                        let errorString = error.userInfo["error"] as? String
                        self.alertController.title = "Sign Up Error"
                        self.alertController.message = errorString!
                    } else {
                        print("Signed Up!")
                    }
                }
            }
        } else {
            presentViewController(alertController, animated: true) { }
        }
    }
    
    let alertController = UIAlertController(title: "Title", message: "Message", preferredStyle: .Alert)
    var user: PFUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in }
        alertController.addAction(cancelAction)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func validateForm() -> Bool {
        if emailField.text == "" {
            alertController.title = "Email required"
            alertController.message = "Please enter your email address."
            return false
            
        } else if passwordField == "" {
            alertController.title = "Password required"
            alertController.message = "Please enter your password."
            return false
            
        } else {
            return true
        }
    }


}

