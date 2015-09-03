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
import Social

extension MainViewController: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.searchController.active)
        {
            println("search")
            println(self.searchArray.count)
            return self.searchArray.count
        }
        else
        {
            println("normal")
            println(self.placeItems.count)
            return self.placeItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 
    {
        let cell:PlaceCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlaceCell
        cell.layoutMargins = UIEdgeInsetsZero
        println(self.searchController.active)
        if (self.searchController.active)
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
        
        var GoToAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Itinéraire" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in

            self.locServices.mapsHandler(indexPath, placeItems: self.placeItems,searchArray: self.searchArray,placesSearchController: self.searchController)
            
        })
        
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Partager" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let shareToFacebookButton = NSLocalizedString("Facebook", comment: "Facebook")
            let shareToTwitterButton = NSLocalizedString("Twitter", comment: "Twitter")
            let cancelButton = NSLocalizedString("Annuler", comment: "Annuler")
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            //-- Create the actions
            let shareToFacebookAction = UIAlertAction(title: shareToFacebookButton, style: .Destructive ) { action in
                var shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                var thisTitle: AnyObject! = self.placeItems[indexPath.row].placeName
                shareToFacebook.setInitialText("\(thisTitle) : ce lieu à l'air vraiment génial !")
                self.presentViewController(shareToFacebook, animated: true, completion: nil)
            }
            
            let shareToTwitterAction = UIAlertAction(title: shareToTwitterButton, style: .Destructive) { action in
                var shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                var thisTitle: AnyObject! = self.placeItems[indexPath.row].placeName
                shareToTwitter.setInitialText("\(thisTitle) : ce lieu à l'air vraiment génial !")
                self.presentViewController(shareToTwitter, animated: true, completion: nil)
            }
            
            let cancelAction = UIAlertAction(title: cancelButton, style: .Cancel) { action in
                alertController.dismissViewControllerAnimated(true, completion: {
                    self.performSegueWithIdentifier("postview", sender: self)
                })
            }
            
            //-- Add the actions.
            alertController.addAction(shareToFacebookAction)
            alertController.addAction(shareToTwitterAction)
            alertController.addAction(cancelAction)
            
            //-- Configure the alert controller's popover presentation controller if it has one.
            /*if let popoverPresentationController = alertController.popoverPresentationController {
                // This method expects a valid cell to display from.
                let selectedCell = tableView.cellForRowAtIndexPath(selectedIndexPath)!
                popoverPresentationController.sourceRect = selectedCell.frame
                popoverPresentationController.sourceView = view
                popoverPresentationController.permittedArrowDirections = .Up
            }*/
            
           self.presentViewController(alertController, animated: true, completion: nil)

        })
        
        shareAction.backgroundColor = UIColorFromRGB(0x5B90CE)
        var FavorisAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Favoris" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            //do favoris action
        })
        
        FavorisAction.backgroundColor = UIColorFromRGB(0x4B75B2)
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
        QServices.post("POST", params:["object":"object"], url: "http://151.80.128.136:3000/search/places/"+searchController.searchBar.text){
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
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData.reloadData()

//                self.searchController.s(self.tableData.layer)
            })
            
        }

    }
}

extension MainViewController: CLLocationManagerDelegate
{
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
            manager.stopUpdatingLocation()
        
            //println(manager.location)
        
            let settingViewController = SettingsViewController()
            
            var userLatitude = String(stringInterpolationSegment: manager.location.coordinate.latitude)
            var userLongitude = String(stringInterpolationSegment: manager.location.coordinate.longitude)
            println("Latitude \(userLatitude)")
            println("Longitude \(userLongitude)")
            var ageMin = String(stringInterpolationSegment: settingViewController.userDefaults.floatForKey("AgeMinValue"))
            println("ageMin \(ageMin)")
            var ageMax = String(stringInterpolationSegment: settingViewController.userDefaults.floatForKey("AgeMaxValue"))
            println("AgeMax \(ageMax)")
            var distanceMax = String(stringInterpolationSegment: settingViewController.userDefaults.floatForKey("DistanceValue"))
            println("Distance max \(distanceMax)")
            
            /*if (distanceMax == "0.0"){
                distanceMax = "10"
            }*/
        
            
            let userDataFb = UserDataFb()
            userDataFb.getFriends()
            var friends: AnyObject? = settingViewController.userDefaults.objectForKey("friends")
            println("MyFriends\(friends)" )
            
            
            //locServices.doQueryPost(&placeItems,tableData: tableData,isRefreshing: false)
            self.QServices.post("POST", params:["latitude":userLatitude, "longitude": userLongitude, "collection": "places", "age_min" : ageMin, "age_max" : ageMax, "distance_max" : distanceMax], url: "http://151.80.128.136:3000/list/had/") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                //var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                
                
                var locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: self.locServices.latitude), "longitude" : String(stringInterpolationSegment: self.locServices.longitude)]
                
                
                if let reposArray = obj["listbar"] as? [NSDictionary]  {
                    //println("ReposArray \(reposArray)")
                    println("RefreshhhYouhou")
                    
                    if(self.isAnimating == true) {
                        self.placeItems.removeAll()
                    }
                    
                    for item in reposArray {
                        self.placeItems.append(PlaceItem(json: item, userLocation : locationDictionary))
                        //println("Item \(item)")
                    }
                }
                println("Mon object \(obj)")
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.tableData.reloadData()
                    
                })
            }

    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
}

extension MainViewController: UISearchBarDelegate
{
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.setLogoNavBar()
    }
}
