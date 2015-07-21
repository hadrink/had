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
