//
//  MainViewControllerExtensions.swift
//  had
//
//  Created by chrisdegas on 15/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

extension MainViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.placesSearchController.active)
        {
            println("search")
            println(self.searchArray.count)
            return self.searchArray.count
        }
        else
        {
            println("noraml")
            println(self.placeItems.count)
            return self.placeItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 
    {
        let cell:PlaceCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlaceCell
        cell.layoutMargins = UIEdgeInsetsZero
        println(self.placesSearchController.active)
        if (self.placesSearchController.active)
        {
            println("active reload")
            cell.placeName.text = searchArray[indexPath.row].placeName as String?
            cell.city.text = searchArray[indexPath.row].city as String?
            cell.nbUser.text = (searchArray[indexPath.row].counter as String!)
            cell.averageAge.text = String(stringInterpolationSegment: searchArray[indexPath.row].averageAge)
            cell.details.text = String(stringInterpolationSegment: searchArray[indexPath.row].pourcentFemale)
            cell.distance.text = String(stringInterpolationSegment: searchArray[indexPath.row].distance) + "km"
            return cell
        }
            
        else
        {
            println("inactive")
            cell.placeName.text = placeItems[indexPath.row].placeName as String?
            cell.city.text = placeItems[indexPath.row].city as String?
            cell.nbUser.text = (placeItems[indexPath.row].counter as String!)
            cell.averageAge.text = String(stringInterpolationSegment: placeItems[indexPath.row].averageAge)
            cell.details.text = String(stringInterpolationSegment: placeItems[indexPath.row].pourcentFemale)
            cell.distance.text = String(stringInterpolationSegment: placeItems[indexPath.row].distance) + "km"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // Aller
        var GoToAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Itinéraire" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            self.locServices.mapsHandler(indexPath, placeItems: self.placeItems,searchArray: self.searchArray,placesSearchController: self.placesSearchController)
            
        })
        /*var button: UIButton = UIButton()
        button.backgroundColor = UIColor(red: 30, green: 30, blue: 30, alpha: 30)
        button.setImage(UIImage(named: "location-icon@10x"), forState: UIControlState.Normal)
        var mut: NSMutableArray = NSMutableArray()
        mut.addObject(button)*/
        /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = color;
        [button setImage:icon forState:UIControlStateNormal];
        [self addObject:button];
        var color30 = UIColor(red: 30, green: 30, blue: 30, alpha: 30)
        color30.*/
        //
        //GoToAction.backgroundColor = UIColor(patternImage: UIImage(named:"location-icon@10x")!)
        //GoToAction.backgroundColor = UIColor(red: 30, green: 30, blue: 30, alpha: 30)
        // 3
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Partager" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //do share action
        })
        shareAction.backgroundColor = UIColorFromRGB(0x5B90CE)
        var FavorisAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Favoris" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //do favoris action
        })
        FavorisAction.backgroundColor = UIColorFromRGB(0x4B75B2)
        // 5
        return [GoToAction,shareAction,FavorisAction]
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if placeItems.count != 0
        {
            self.tableData.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            return 1;
        }
        else
        {
            // Display a message when the table is empty
            messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            //messageLabel.text = "No data is currently available. Please pull down to refresh."
            messageLabel.textColor = UIColor.blackColor()
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont(name: "Palatino-Italic", size: 20)
            messageLabel.sizeToFit()
            
            self.tableData.backgroundView = messageLabel
            self.tableData.separatorStyle = UITableViewCellSeparatorStyle.None
            
        }
        return 1
    }

}

extension MainViewController: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(selectedIndex == indexPath.row){
            selectedIndex = -1
            tableData.reloadRowsAtIndexPaths(NSArray(object: indexPath) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
            return
        }
        if(selectedIndex != -1){
            var prevPath:NSIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
            tableData.reloadRowsAtIndexPaths(NSArray(object: prevPath) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        selectedIndex = indexPath.row
        tableView.reloadRowsAtIndexPaths(NSArray(object: indexPath) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}

extension MainViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.searchArray.removeAll()
        QServices.post(["object":"object"], url: "http://151.80.128.136:3000/search/places/"+searchController.searchBar.text){
            (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
            
            var locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: self.locServices.latitude), "longitude" : String(stringInterpolationSegment: self.locServices.longitude)]
            
            if let reposArray = obj["searchlist"] as? [NSDictionary]  {
                //println("ReposArray \(reposArray)")
                
                for item in reposArray {
                    self.searchArray.append(PlaceItem(json: item, userLocation : locationDictionary))
                    //println("Item \(item)")
                    println("has Item")
                }
                
            }
            println("reload")
            //self.tableData.reloadData()
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData.reloadData()
            })
            
            //println("Mon object \(obj)")
        }

        //let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text)
        //let array = (self.placeItems as NSArray!).filteredArrayUsingPredicate(searchPredicate)
  //      println(array)
//        self.searchArray = array as! [PlaceItem]
    }
}

extension MainViewController: CLLocationManagerDelegate
{
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                var latLng = self.getLocationInfo(pm)
                //println(latLng[0])
                //println(latLng[1])
            } else {
                println("Problem with the data received from geocoder")
            }
            
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
}
