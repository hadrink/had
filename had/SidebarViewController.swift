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
        
        var cellIdentifier:NSString = self.menuItems.objectAtIndex(indexPath.row) as NSString
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        
        return cell
        
    }
    
    override func  prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBOutlet var menu: UITableView!
    @IBOutlet weak var bgTableView: UIImageView!
}

