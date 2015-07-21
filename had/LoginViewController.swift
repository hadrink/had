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
        if (FBSDKAccessToken.currentAccessToken() != nil || hasLoginKey == true)
        {
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
            println("redirect sw")
            let QServices = QueryServices()
            QServices.returnUserData()
        }
        else
        {
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("Introduction")
            println("redirect intro")
        }
        self.showViewController(vc as! UIViewController, sender: vc)

    }
    

}

