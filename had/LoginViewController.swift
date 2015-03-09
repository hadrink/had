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
    override func viewDidAppear(animated: Bool) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.userProfil.getUserCoreData()
        println("getuser")
        var mail=appDelegate.userProfil.mail
        var vc: AnyObject!
        if(((mail?.isEmpty) != nil) && ((mail?) != "")){
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
        }
        else{
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("Introduction")
        }
        self.showViewController(vc as UIViewController, sender: vc)
        println("redirect")
        
    }
}

