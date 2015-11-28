//
//  SideBarController.swift
//  had
//
//  Created by Chris Degas on 24/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit


class SidebarViewController: UITableViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        menuItems = ["ou","flux","setting","turnoff"]
        
        
    }
    
    var menuItems:NSArray = []
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier:NSString = self.menuItems.objectAtIndex(indexPath.row) as! NSString
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier as String, forIndexPath: indexPath) 
        
        
        return cell
        
    }

    @IBAction func disconnect(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasLoginKey")
        NSUserDefaults.standardUserDefaults().synchronize()
        print(NSUserDefaults.standardUserDefaults().valueForKey("hasLoginKey"))
        //let loginManager = FBSDKLoginManager()
        //loginManager.logOut()
/*        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        appDelegate.userProfil.getUserCoreData()
        println("getuser")
        appDelegate.userProfil.disconnect()*/
        let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Introduction")
        self.showViewController(vc as! UIViewController, sender: vc)
        print("disconnect")
    }
   
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBOutlet var menu: UITableView!
    @IBOutlet weak var bgTableView: UIImageView!
}

