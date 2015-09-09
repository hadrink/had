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
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
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
    
            //println(manager.location)
        if UIApplication.sharedApplication().applicationState == .Active {
            println("app is activated")
            manager.stopUpdatingLocation()
            
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
        
        } else {
            NSLog("App is backgrounded. New location is %@", manager.location)
            let userDefaults = NSUserDefaults.standardUserDefaults()
            var email: String! = userDefaults.stringForKey("email")
            QServices.post("POST", params:["object":"object"], url: "http://151.80.128.136:3000/usercoordinate/user/\(email)/\(manager.location.coordinate.latitude)/\(manager.location.coordinate.longitude)") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                println("dans le post du backgroundeuuuux")
            }
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

extension MainViewController
{
    
    func setupRefreshControl() {
        println()
        
        // Programmatically inserting a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        
        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = UIView(frame: self.refreshControl.bounds)
        self.refreshLoadingView.backgroundColor = UIColor.clearColor()
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = UIView(frame: self.refreshControl.bounds)
        self.refreshColorView.backgroundColor = UIColor.clearColor()
        self.refreshColorView.alpha = 0.30
        
        // Create the graphic image views
        town_background = UIImageView(image: UIImage(named: "pull-to-refresh-bg@3x"))
        //compass_background.frame.size.width = 375
        //compass_background.frame.size.height = 10
        
        self.bottle_spinner = UIImageView(image: UIImage(named: "bottle-spin@3x"))
        self.bottle_spinner.frame.size = CGSize(width: 42, height: 42)
        
        
        // Add the graphics to the loading view
        self.refreshLoadingView.addSubview(self.town_background)
        self.refreshLoadingView.addSubview(self.bottle_spinner)
        
        // Clip so the graphics don't stick out
        self.refreshLoadingView.clipsToBounds = true;
        
        // Hide the original spinner icon
        self.refreshControl.tintColor = UIColor.clearColor()
        
        // Add the loading and colors views to our refresh control
        self.refreshControl.addSubview(self.refreshColorView)
        self.refreshControl.addSubview(self.refreshLoadingView)
        
        // Initalize flags
        self.isRefreshIconsOverlap = false;
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refresh(){
        println()
        
        // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
        // This is where you'll make requests to an API, reload data, or process information
        var delayInSeconds = 3.0;
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            // When done requesting/reloading/processing invoke endRefreshing, to close the control
            self.refreshControl.endRefreshing()
        }
        // -- FINISHED SOMETHING AWESOME, WOO! --
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl.bounds;
        
        // Distance the table has been pulled >= 0
        var pullDistance = max(0.0, -self.refreshControl.frame.origin.y);
        
        // Half the width of the table
        var midX = self.tableData.frame.size.width / 2.0;
        
        // Calculate the width and height of our graphics
        var compassHeight = self.town_background.bounds.size.height + 120;
        var compassHeightHalf = compassHeight / 2.0;
        
        var compassWidth = self.town_background.bounds.size.width;
        var compassWidthHalf = compassWidth / 2.0;
        
        var spinnerHeight = self.bottle_spinner.bounds.size.height;
        var spinnerHeightHalf = spinnerHeight / 2.0;
        
        var spinnerWidth = self.bottle_spinner.bounds.size.width;
        var spinnerWidthHalf = spinnerWidth / 2.0;
        
        // Calculate the pull ratio, between 0.0-1.0
        var pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0;
        
        // Set the Y coord of the graphics, based on pull distance
        var compassY = pullDistance / 2.0 - compassHeightHalf;
        var spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
        
        // Calculate the X coord of the graphics, adjust based on pull ratio
        var compassX = midX + compassWidthHalf - compassWidth;
        var spinnerX = midX - spinnerWidthHalf;
        
        // When the compass and spinner overlap, keep them together
        if (fabsf(Float(compassX - spinnerX)) < 1.0) {
            self.isRefreshIconsOverlap = true;
        }
        
        // If the graphics have overlapped or we are refreshing, keep them together
        if (self.isRefreshIconsOverlap || self.refreshControl.refreshing) {
            compassX = midX - compassWidthHalf;
            spinnerX = midX - spinnerWidthHalf;
        }
        
        // Set the graphic's frames
        var compassFrame = self.town_background.frame;
        compassFrame.origin.x = compassX;
        compassFrame.origin.y = compassY;
        
        var spinnerFrame = self.bottle_spinner.frame;
        spinnerFrame.origin.x = spinnerX;
        spinnerFrame.origin.y = spinnerY;
        
        self.town_background.frame = compassFrame;
        self.bottle_spinner.frame = spinnerFrame;
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        
        self.refreshColorView.frame = refreshBounds;
        self.refreshLoadingView.frame = refreshBounds;
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshControl.refreshing && !self.isRefreshAnimating) {
            self.animateRefreshView()
        }
        
        println("pullDistance \(pullDistance), pullRatio: \(pullRatio), midX: \(midX), refreshing: \(self.refreshControl.refreshing)")
    }
    
    func animateRefreshView() {
        println()
        
        // Background color to loop through for our color view
        
        var colorArray = [UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.orangeColor(), UIColor.magentaColor()]
        
        // In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
        }
        
        // Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animateWithDuration(
            Double(0.3),
            delay: Double(0.0),
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                self.bottle_spinner.transform = CGAffineTransformRotate(self.bottle_spinner.transform, CGFloat(M_PI_2))
                
                // Change the background color
                self.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
                ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
            },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if (self.refreshControl.refreshing) {
                    self.animateRefreshView()
                }else {
                    self.resetAnimation()
                }
            }
        )
    }
    
    func resetAnimation() {
        println()
        
        // Reset our flags and }background color
        self.isRefreshAnimating = false;
        self.isRefreshIconsOverlap = false;
        self.refreshColorView.backgroundColor = UIColor.clearColor()
    }

}
