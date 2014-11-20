//
//  SidePanelViewController.swift
//  had
//
//  Created by Chris Degas on 20/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//


import UIKit

@objc
protocol SidePanelViewControllerDelegate {
    func informationSelected(info: Information)
}

class SidePanelViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    var informations: Array<Information>!
    
    struct TableView {
        struct CellIdentifiers {
            static let info = "Information"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    // MARK: Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return informations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.info, forIndexPath: indexPath) as InformationCell
        cell.configureForInformation(informations[indexPath.row])
        return cell
    }
    
    // Mark: Table View Delegate
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let selectedInformation = informations[indexPath.row]
        delegate?.informationSelected(selectedInformation)
    }
    
}

class InformationCell: UITableViewCell {
   
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var imageCreatorLabel: UILabel!
    
    func configureForInformation(info: Information) {
        imageNameLabel.text = info.title
        imageCreatorLabel.text = info.creator
    }
}
