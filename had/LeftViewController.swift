//
//  SideBarController.swift
//  had
//
//  Created by Chris Degas on 24/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit

@objc
protocol LeftViewControllerDelegate {
    func menuItemSelected(item: MenuItem)
}

class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: LeftViewControllerDelegate?
    var menuItems: Array<MenuItem>!
    
    struct TableView {
        struct CellIdentifiers {
            static let MenuCell = "MenuCell"
        }
    }
    
    var backgroundImage : UIImageView = UIImageView(image: UIImage(contentsOfFile: "bg-had.png"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.layer.backgroundColor = HadColor.Color.backgroundColor.CGColor
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.MenuCell, forIndexPath: indexPath) as MenuCell
        cell.configureForMenuItem(menuItems[indexPath.row])
        if(menuItems[indexPath.row].status == "active"){
            cell.backgroundColor = UIColor.whiteColor()
        }else{
            cell.backgroundColor = UIColor.clearColor()
        }

        return cell
    }
    
    // Mark: Table View Delegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let selectedMenuItem = menuItems[indexPath.row]
        delegate?.menuItemSelected(selectedMenuItem)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.tableView.rowHeight = 80
        return self.tableView.rowHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView: UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 30.0))

        sectionHeaderView.backgroundColor = UIColor.clearColor()
        
        var headerLabel: UILabel = UILabel(frame: CGRectMake(20, 12.5, sectionHeaderView.frame.size.width, 25.0))
        headerLabel.backgroundColor = UIColor.clearColor()
        headerLabel.textColor = UIColor.whiteColor()
        
        headerLabel.font = UIFont(name: "SignPainter", size: 30.0)
        sectionHeaderView.addSubview(headerLabel)

        headerLabel.text = "Had"
        
        return sectionHeaderView;
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionHeaderView: UIView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 30.0))
        
        sectionHeaderView.backgroundColor = UIColor.clearColor()
        
        var headerLabel: UILabel = UILabel(frame: CGRectMake(20, 15, sectionHeaderView.frame.size.width, 25.0))
        headerLabel.backgroundColor = UIColor.clearColor()
        
        headerLabel.font = UIFont(name: "SignPainter", size: 20.0)
        sectionHeaderView.addSubview(headerLabel)
        
        return sectionHeaderView;
    }
}

