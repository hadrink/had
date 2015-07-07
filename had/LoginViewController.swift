//
//  LoginViewController.swift
//  had
//
//  Created by chrisdegas on 09/03/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController{
    
    override func viewDidAppear(animated: Bool){

        let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        println(NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey"))
        var vc: AnyObject!
        println("willappear")
//        self.performSegueWithIdentifier("loggedIn", sender: self)
        if (FBSDKAccessToken.currentAccessToken() != nil || hasLoginKey == true)
        {
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
            println("redirect sw")
            returnUserData()
        }
        else
        {
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("Introduction")
            println("redirect intro")
        }
        self.showViewController(vc as! UIViewController, sender: vc)
        /*let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        //appDelegate.userProfil.getUserCoreData()
        appDelegate.userProfil.loadUser()
        println("getuser")
        var mail=appDelegate.userProfil.mail
        var vc: AnyObject!
        if(((mail?.isEmpty) != nil) && ((mail?) != "")){
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
            println("redirect sw")
        }
        else{
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("Introduction")
            println("redirect intro")
        }
        self.showViewController(vc as UIViewController, sender: vc)*/

        
    }
    
    func returnUserData()
    {
        
//        FBSDKGraphRequestConnection
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)

        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
                let gender : NSString = result.valueForKey("gender") as! NSString
                println("User gender is: \(gender)")
                let local : NSString = result.valueForKey("locale") as! NSString
                println("User local is: \(local)")
                let link : NSString = result.valueForKey("link") as! NSString
                println("User link is: \(link)")

            }
        })
    }
}

