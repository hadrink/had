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
            print("search")
            print(self.searchArray.count)
            return self.searchArray.count
        }
        else
        {
            print("normal")
            print(self.placeItems.count)
            return self.placeItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:PlaceCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlaceCell

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 16.0, bottom: 0, right: 0)
        print(self.searchController.active)
        
        if (self.searchController.active)
        {
            print("active reload")
            
            cell.placeName.text = searchArray[indexPath.row].placeName as String?
            cell.city.text = searchArray[indexPath.row].city as String?
            cell.nbUser.text = String(searchArray[indexPath.row].counter)
            cell.averageAge.text = String(stringInterpolationSegment: searchArray[indexPath.row].averageAge)
            cell.details.text = String(stringInterpolationSegment: searchArray[indexPath.row].pourcentSex)
            cell.distance.text = String(stringInterpolationSegment: searchArray[indexPath.row].distance) + "km"
            
            let type = searchArray[indexPath.row].typeofPlace as String!
            
            if ( type == "cafe" || type == "bar") { 
                cell.iconTableview.image = UIImage(named: "bar-icon")
            }
                
            else {
                cell.iconTableview.image = UIImage(named: "nightclub-icon")
            }
            
            return cell
        }
            
        else
        {
            
            let type = placeItems[indexPath.row].typeofPlace as String!
            
            print("inactive")
            //println(placeItems[indexPath.row])
            cell.placeName.text = placeItems[indexPath.row].placeName as String?
            cell.city.text = placeItems[indexPath.row].city as String?
            cell.nbUser.text = String(placeItems[indexPath.row].counter)
            cell.averageAge.text = String(placeItems[indexPath.row].averageAge) + " - " + String(placeItems[indexPath.row].averageAge != nil ? placeItems[indexPath.row].averageAge + 1 : 0)
            cell.details.text = String(format: "%.0f", round(placeItems[indexPath.row].pourcentSex))
            cell.distance.text = String(stringInterpolationSegment: placeItems[indexPath.row].distance) + "km"
            cell.sexIcon.image = placeItems[indexPath.row].sexIcon
            cell.backgroundSex.backgroundColor = placeItems[indexPath.row].majoritySex == "F" ? Colors().pink : Colors().blue
            
            cell.backgroundSex.layer.cornerRadius = 4.0
            cell.backgroundAge.layer.cornerRadius = 4.0
            cell.backgroundNbUser.layer.cornerRadius = 4.0
            
            //-- Get friends array
            let friends = placeItems[indexPath.row].friends
            
            //-- Create an ImageView array
            var friendsImageView: [UIImageView?] = []
            friendsImageView.append(cell.fbFriendsImg1)
            friendsImageView.append(cell.fbFriendsImg2)
            friendsImageView.append(cell.fbFriendsImg3)
            
            //-- Check if friends in place
            if friends!.count > 0 {
                
                //-- Create index for friends
                let indexFriends = friends!.count - 1
                
                //-- Loop on userId in friends
                for userId in 0...indexFriends {
                    
                    //-- Corner radius (makes circle picture)
                    friendsImageView[userId]?.frame.size = CGSize(width: 30, height: 30)
                    friendsImageView[userId]?.layer.cornerRadius = (friendsImageView[userId]?.frame.size.width)! / 2
                    
                    //-- Create picture friends url request
                    let url: NSURL! = NSURL(string: "https://graph.facebook.com/\(friends![userId])/picture?width=90&height=90")
                    let request:NSURLRequest = NSURLRequest(URL:url)
                    let queue:NSOperationQueue = NSOperationQueue()
                    
                    //-- Start async request for get facebook picture friends
                    NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ response, data, error in
                        
                        //-- Check if response != nil
                        if((response) != nil) {
                            
                            //-- Lunch async request in main queue for UI elements
                            dispatch_async(dispatch_get_main_queue()) {
                                friendsImageView[userId]?.image = UIImage(data: data!)
                            }
                        }
                    })
                }
            }
            
            //-- Check if users in place (If true elements display else none)
            if placeItems[indexPath.row].counter == nil {
                print("index")
                print(indexPath.row)
                cell.backgroundNbUser.layer.opacity = 0
                cell.backgroundAge.layer.opacity = 0
                cell.backgroundSex.layer.opacity = 0
                cell.fbFriendsImg1.layer.opacity = 0
                cell.fbFriendsImg2.layer.opacity = 0
                cell.fbFriendsImg3.layer.opacity = 0
                tableData.rowHeight = 55
            } else {
                tableData.rowHeight = 120
                cell.backgroundNbUser.layer.opacity = 1
                cell.backgroundAge.layer.opacity = 1
                cell.backgroundSex.layer.opacity = 1
                cell.fbFriendsImg1.layer.opacity = 1
                cell.fbFriendsImg2.layer.opacity = 1
                cell.fbFriendsImg3.layer.opacity = 1
            }

            if ( type == "cafe" || type == "bar") {
                cell.iconTableview.image = UIImage(named: "bar-icon")
            }
                
            else {
                cell.iconTableview.image = UIImage(named: "nightclub-icon")
            }
            
            //-- Init settingViewController and variable ageMin ageMax
            let settingViewController = SettingsViewController()
            var ageMin : Double
            var ageMax : Double
            
            //-- If userDefault value exist use it, else take the default value
            if (settingViewController.userDefaults.floatForKey("AgeMinValue").isZero && settingViewController.userDefaults.floatForKey("AgeMaxValue").isZero ) {
                ageMin = settingDefault.ageMin
                ageMax = settingDefault.ageMax
            } else {
                ageMin = settingViewController.userDefaults.doubleForKey("AgeMinValue")
                ageMax = settingViewController.userDefaults.doubleForKey("AgeMaxValue")
            }
            
            //-- Check if average Age is between ageMax and ageMin and hide cell if it's false
            if placeItems[indexPath.row].averageAge != nil {
                if (placeItems[indexPath.row].averageAge < Int(ageMin) && placeItems[indexPath.row].averageAge < Int(ageMax) || placeItems[indexPath.row].averageAge > Int(ageMin) && placeItems[indexPath.row].averageAge > Int(ageMax)) {
                    cell.hidden = true
                    tableData.rowHeight = 0
                }
            
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        var GoActionTitle:String = "Itinéraire"
        /*var fontSize_iOS8AndUpDefault  = 18.0
        var fontSize_actuallyUsedUnderImage = 13.0
        
        var margin_horizontal_iOS8AndUp = 15.0
        var margin_vertical_betweenTextAndImage = 2.0
        if(tableView.cellForRowAtIndexPath(indexPath)?.heightAnchor as? double >= 64.0){
            margin_vertical_betweenTextAndImage =  3.0
        }*/
        
        let GoToAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: GoActionTitle , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
            self.locServices.mapsHandler(indexPath, placeItems: self.placeItems,searchArray: self.searchArray,placesSearchController: self.searchController)
            
        })
        
        GoToAction.backgroundColor = Colors().blue
        //----------------------------
       /* NSString.stringByPaddingToLength(GoActionTitle)
        var titleSpaceString:NSString = stringByPaddingToLength(GoAction.length()*(fontSize_actuallyUsedUnderImage/fontSize_iOS8AndUpDefault)/1.1f withString:"\u3000" startingAtIndex:0); // This isn't exact, but it's close enough in most instances? I tested with full-width Asian characters and it accounts for those pretty well.
        
        var frameGuess:CGSize =CGSizeMake(15*2, <#T##height: CGFloat##CGFloat#>)
        CGSizeMake((margin_horizontal_iOS8AndUp*2)+[titleSpaceString boundingRectWithSize:CGSizeMake(MAXFLOAT, cellHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize_iOS8AndUpDefault] } context:nil].size.width, cellHeight);
        
        var tripleFrame:CGSize=CGSizeMake(frameGuess.width*3.0f, frameGuess.height*3.0f);
        
        UIGraphicsBeginImageContextWithOptions(tripleFrame, YES, [[UIScreen mainScreen] scale]);
        CGContextRef context=UIGraphicsGetCurrentContext();
        
        [backgroundColor set];
        CGContextFillRect(context, CGRectMake(0, 0, tripleFrame.width, tripleFrame.height));
        
        CGSize drawnTextSize=[title boundingRectWithSize:CGSizeMake(MAXFLOAT, cellHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize_actuallyUsedUnderImage] } context:nil].size;
        
        [image drawAtPoint:CGPointMake((frameGuess.width/2.0f)-([image size].width/2.0f), (frameGuess.height/2.0f)-[image size].height-(margin_vertical_betweenTextAndImage/2.0f)+2.0f)];
        [title drawInRect:CGRectMake((frameGuess.width/2.0f)-(drawnTextSize.width/2.0f), (frameGuess.height/2.0f)+(margin_vertical_betweenTextAndImage/2.0f)+2.0f, frameGuess.width, frameGuess.height) withAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:fontSize_actuallyUsedUnderImage], NSForegroundColorAttributeName: [UIColor whiteColor] }];
        
        [rowAction setBackgroundColor:[UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()]];
        UIGraphicsEndImageContext();*/
        //----------------------------
        let shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Partager" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
            let shareToFacebookButton = NSLocalizedString("Facebook", comment: "Facebook")
            let shareToTwitterButton = NSLocalizedString("Twitter", comment: "Twitter")
            let cancelButton = NSLocalizedString("Annuler", comment: "Annuler")
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            //-- Create the actions
            let shareToFacebookAction = UIAlertAction(title: shareToFacebookButton, style: .Destructive ) { action in
                let shareToFacebook : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                let thisTitle: AnyObject! = self.placeItems[indexPath.row].placeName
                shareToFacebook.setInitialText("\(thisTitle) : ce lieu à l'air vraiment génial !")
                self.presentViewController(shareToFacebook, animated: true, completion: nil)
            }
            
            let shareToTwitterAction = UIAlertAction(title: shareToTwitterButton, style: .Destructive) { action in
                let shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                let thisTitle: AnyObject! = self.placeItems[indexPath.row].placeName
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
            
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        })
        
        shareAction.backgroundColor = Colors().blue
        return [GoToAction,shareAction]
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
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
    
}

extension MainViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let isEmpty = searchController.searchBar.text?.isEmpty
        if(isEmpty == false){
            let textSearch = searchController.searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
            self.searchArray.removeAll()
            QServices.post("POST", params:["object":"object"], url: "http://151.80.128.136:3000/search/places/"+textSearch!){
                (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                
                 let locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: self.locServices.latitude), "longitude" : String(stringInterpolationSegment: self.locServices.longitude)]
                
                if let reposArray = obj["searchlist"] as? [NSDictionary]  {
                //println("ReposArray \(reposArray)")
                
                for item in reposArray {
                self.searchArray.append(PlaceItem(json: item, userLocation : locationDictionary))
                //println("Item \(item)")
                print("has Item")
                }
                
                }
                print("reload")
                
                dispatch_async(dispatch_get_main_queue(), {
                self.tableData.reloadData()
                })
                
            }
        }
    }
}

extension MainViewController: CLLocationManagerDelegate
{
    
    //-- Func Observer Method for start Updating Location
    
    func myObserverMethod (notification: NSNotification) {
//
//        if #available(iOS 9.0, *) {
//            locationManager.requestLocation()
//        } else {
//            // Fallback on earlier versions
//            locationManager.startUpdatingLocation()
//        }
        print("allow dans l'observer")
        if #available(iOS 9.0, *) {
            self.locationManager.allowsBackgroundLocationUpdates = true
        //    self.locationManager.requestLocation()
            print(self.locationManager.allowsBackgroundLocationUpdates)
        }
        self.locationManager.startUpdatingLocation()
        //self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func WillAppTerminate(notification: NSNotification){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let email: String! = userDefaults.stringForKey("email")
        QServices.post("POST", params:["object":"object"], url: "http://151.80.128.136:3000/usercoordinate/user/\(email)/\(self.locationManager.location!.coordinate.latitude)/\(self.locationManager.location!.coordinate.longitude)") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
            print("dans le post du backgroundeuuuux")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        print("deferredUpdates")
    }
    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        switch(status){
//        case .AuthorizedAlways:
//            self.isLocating=true
//            break
//        default:
//            self.isLocating=false
//        }
//        
//        startLocationManager()
//        print(" authorisation status change")
//    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if((locationManager.location) != nil)
        {
            locServices.latitude = locationManager.location!.coordinate.latitude
            locServices.longitude = locationManager.location!.coordinate.longitude
            let userLatitude = String(stringInterpolationSegment: manager.location!.coordinate.latitude)
            let userLongitude = String(stringInterpolationSegment: manager.location!.coordinate.longitude)
            if UIApplication.sharedApplication().applicationState == .Active {
                print("app is activated")
                
                locationManager.stopUpdatingLocation()
                
                
                //let userLatitude = String(stringInterpolationSegment: manager.location!.coordinate.latitude)
                //let userLongitude = String(stringInterpolationSegment: manager.location!.coordinate.longitude)
                print("Latitude \(userLatitude)")
                print("Longitude \(userLongitude)")
                
                //-- Variable send to the method post
                
                var distanceMax: Float
                var ageMin : Double
                var ageMax : Double
                var displayBar : Bool
                var displayNightclub : Bool
                var statsSince : Int
                
                //-- Check if value exist in the userDefault Setting else we get the default values
                
                let settingViewController = SettingsViewController()
                
                if (settingViewController.userDefaults.floatForKey("AgeMinValue").isZero && settingViewController.userDefaults.floatForKey("AgeMaxValue").isZero ) {
                    ageMin = settingDefault.ageMin
                    ageMax = settingDefault.ageMax
                } else {
                    ageMin = settingViewController.userDefaults.doubleForKey("AgeMinValue")
                    ageMax = settingViewController.userDefaults.doubleForKey("AgeMaxValue")
                }
                
                if (settingViewController.userDefaults.floatForKey("DistanceValue").isZero) {
                    distanceMax = settingDefault.distanceMax
                } else {
                    distanceMax = settingViewController.userDefaults.floatForKey("DistanceValue")
                }
                
                if (settingViewController.userDefaults.objectForKey("SwitchStateBar") != nil) {
                    displayBar = settingViewController.userDefault.boolForKey("SwitchStateBar")
                    print("SwitchStateBar")
                } else {
                    displayBar = settingDefault.displayBar
                    print("default setting")
                }
                
                if (settingViewController.userDefaults.objectForKey("SwitchStateNightclub") != nil) {
                    displayNightclub = settingViewController.userDefault.boolForKey("SwitchStateNightclub")
                } else {
                    displayNightclub = settingDefault.displayNightclub
                }
                
                if (settingViewController.userDefaults.objectForKey("stats_since") != nil) {
                    statsSince = settingViewController.userDefaults.integerForKey("stats_since")
                    print("Value \(statsSince)")
                } else {
                    statsSince = settingDefault.statsSince
                    print("stats \(statsSince)")
                }
                
                //-- Transform to String
                
                let distanceMaxString = String(stringInterpolationSegment: distanceMax)
                print("Distance max \(distanceMax)")
                let ageMinString = String(stringInterpolationSegment: ageMin)
                let ageMaxString = String(stringInterpolationSegment: ageMax)
                
                let formatter: NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                
                let userDataFb = UserDataFb()
                userDataFb.getFriends()
                let friends: AnyObject? = settingViewController.userDefaults.objectForKey("friends")
                print("MyFriends\(friends)" )
                
                //locServices.doQueryPost(&placeItems,tableData: tableData,isRefreshing: false)
                self.QServices.post("POST", params:["latitude":userLatitude, "longitude": userLongitude, "collection": "places", "age_min" : ageMinString, "age_max" : ageMaxString, "distance_max" : distanceMaxString, "bar" : displayBar, "nightclub" : displayNightclub, "date" : statsSince], url: Urls.urlListPlace) { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                    //var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                    
                    
                    let locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: self.locServices.latitude), "longitude" : String(stringInterpolationSegment: self.locServices.longitude)]
                    
                    if let reposArray = obj["listbar"] as? [NSDictionary]  {
                        self.placeItems.removeAll()
                        
                        for item in reposArray {
                            if var placeProperties = item["properties"] as? [String:AnyObject] {
                                if (placeProperties["name"] != nil) {
                                    self.placeItems.append(PlaceItem(json: item, userLocation : locationDictionary))
                                }
                            }
                        }
                    }
                    //print("Mon object \(obj)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.tableData.reloadData()
                        
                    })
                }
                
            } else {
                NSLog("App is backgrounded. New location is %@", manager.location!)
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let email: String! = userDefaults.stringForKey("email")
                QServices.post("POST", params:["object":"object"], url: "http://151.80.128.136:3000/usercoordinate/user/\(email)/\(userLatitude)/\(userLongitude)") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                }
                
                let distance:CLLocationDistance = 200
                let time:NSTimeInterval = 10
                manager.allowDeferredLocationUpdatesUntilTraveled(distance, timeout: time)
                
            }
            locationManager = nil
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location" + error.localizedDescription)
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
        print("")
        // Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = UIView(frame: self.refreshControl.bounds)
        self.refreshLoadingView.backgroundColor = UIColor.clearColor()
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = UIView(frame: self.refreshControl.bounds)
        self.refreshColorView.backgroundColor = UIColor.clearColor()
        self.refreshColorView.alpha = 0.30
        
        // Create the graphic image views
        town_background = UIImageView(image: UIImage(named: "pull-to-refresh-bg"))
        //compass_background.frame.size.width = 375
        //compass_background.frame.size.height = 10
        
        self.bottle_spinner = UIImageView(image: UIImage(named: "bottle-spin"))
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
        print("")
        
        // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
        // This is where you'll make requests to an API, reload data, or process information
        let delayInSeconds = 3.0;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            // When done requesting/reloading/processing invoke endRefreshing, to close the control
            self.nbAlertDuringRefresh = 0
            self.refreshControl.endRefreshing()
        }
        // -- FINISHED SOMETHING AWESOME, WOO! --
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // Get the current size of the refresh controller
        var refreshBounds = self.refreshControl.bounds;
        
        // Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -self.refreshControl.frame.origin.y);
        
        // Half the width of the table
        let midX = self.tableData.frame.size.width / 2.0;
        
        // Calculate the width and height of our graphics
        let compassHeight = self.town_background.bounds.size.height + 120;
        let compassHeightHalf = compassHeight / 2.0;
        
        let compassWidth = self.town_background.bounds.size.width;
        let compassWidthHalf = compassWidth / 2.0;
        
        let spinnerHeight = self.bottle_spinner.bounds.size.height;
        let spinnerHeightHalf = spinnerHeight / 2.0;
        
        let spinnerWidth = self.bottle_spinner.bounds.size.width;
        let spinnerWidthHalf = spinnerWidth / 2.0;
        
        // Calculate the pull ratio, between 0.0-1.0
        //_ = min( max(pullDistance, 0.0), 100.0) / 100.0;
        
        // Set the Y coord of the graphics, based on pull distance
        let compassY = pullDistance / 2.0 - compassHeightHalf;
        let spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
        
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
        
        //print("pullDistance \(pullDistance), pullRatio: \(pullRatio), midX: \(midX), refreshing: \(self.refreshControl.refreshing)")
    }

    func animateRefreshView() {
        print("")
        
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
                if(self.nbAlertDuringRefresh == 0){
                    self.isAnimating = self.startLocationManager()
                    self.nbAlertDuringRefresh++
                }
                //self.locationManager.startUpdatingLocation()
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
                    if(self.isAnimating && self.nbAlertDuringRefresh == 0){
                        self.locationManager.stopUpdatingLocation()
                    }
                    
                }else {
                    self.resetAnimation()
                }
            }
        )
    }
    
    func resetAnimation() {
        print("")
        
        // Reset our flags and }background color
        self.isRefreshAnimating = false;
        self.isRefreshIconsOverlap = false;
        self.refreshColorView.backgroundColor = UIColor.clearColor()
    }
    
}
