//
//  LoginViewController.swift
//  had
//
//  Created by chrisdegas on 09/03/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import UIKit
import CoreData

/*class LoginViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            
            if user == nil {
                print("Ruh-roh, the user cancelled the Facebook login.")
                return
            } else if user!.isNew {
                print("User just signed up and logged in for the first time.")
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection, result, error in
                    
                    let r = result as! NSDictionary
                    
                    user!["firstName"] = r["first_name"]
                    user!["gender"] = r["gender"]
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    user!["birthDay"] = dateFormatter.dateFromString(r["birthday"] as! String)
                    
                    let pictureURL = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary) ["url"] as! String
                    let url = NSURL(string: pictureURL)
                    let request = NSURLRequest(URL: url!)
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        response, data, error in
                        
                        let imageFile = PFFile(name: "avatar.jpg", data: data!)
                        user!["picture"] = imageFile
                        user!.saveInBackgroundWithBlock(nil)
                    })
                })
            } else {
                print("User logged in through Facebook.")
            }
            
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController")
            self.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
}*/

