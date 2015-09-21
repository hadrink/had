//
//  SearchViewController.swift
//  had
//
//  Created by chrisdegas on 06/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var searchActive : Bool = false
    var data = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    /* Create these variable to hold different data */
    var data0 = ["San Francisco","New York","San Jose","Chicago","Los Angeles","Austin","Seattle"]
    var data1 = ["Data1","Data11","Data111"]
    var data2 = ["Data2","Data22","Data222"]
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        data = data0
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = data.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
            data.removeAll()
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let control = UISegmentedControl(items: ["Seg1","Seg2","Seg3"])
        control.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        if(section == 0){
            return control;
        }
        return nil;
    }

    func valueChanged(segmentedControl: UISegmentedControl) {
        print("Coming in : \(segmentedControl.selectedSegmentIndex)")
        if(segmentedControl.selectedSegmentIndex == 0){
            self.data = self.data0
        } else if(segmentedControl.selectedSegmentIndex == 1){
            self.data = self.data1
        } else if(segmentedControl.selectedSegmentIndex == 2){
            self.data = self.data2
        } else {
            self.data = data0
        }
        self.tableView.reloadData()
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
        if(searchActive){
            cell?.textLabel?.text = filtered[indexPath.row]
        } else {
            cell?.textLabel?.text = data[indexPath.row];
        }
        
        return cell!;
    }
}