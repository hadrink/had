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
import CoreData
import Social

extension UIColor {
    class func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

extension MainViewController: UITableViewDataSource
{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (/*self.searchController.active ||*/ isFavOn)
        {
            return self.searchArray.count
        }
        else
        {
            return self.placeItems.count
        }
    }
    
        
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //-- Get cell
        let cell:PlaceCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PlaceCell
        let settingViewController = SettingsViewController()
        
        //-- Design cell
        cell.alpha = 0
        UIView.animateWithDuration(0.5, animations: { cell.alpha = 1 })
        cell.backgroundSex.layer.borderWidth = 1.5
        cell.backgroundSex.layer.cornerRadius = 4.0
        cell.backgroundAge.layer.cornerRadius = 4.0
        cell.backgroundNbUser.layer.cornerRadius = 4.0
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsets.init(top: 0.0, left: 58.0, bottom: 0, right: 0)
        
        func cellDataMainView() {
            cell.placeName.text = placeItems[indexPath.row].placeName as String?
            cell.city.text = placeItems[indexPath.row].city as String?
            cell.nbUser.text = String(placeItems[indexPath.row].counter)
            cell.averageAge.text = String(placeItems[indexPath.row].averageAge) + " - " + String(placeItems[indexPath.row].averageAge != nil ? placeItems[indexPath.row].averageAge + 1 : 0)
            cell.details.text = String(format: "%.0f", round(placeItems[indexPath.row].pourcentSex))
            cell.details.textColor = placeItems[indexPath.row].majoritySex == "F" ? Colors().pink : Colors().blue
            cell.percent.textColor = placeItems[indexPath.row].majoritySex == "F" ? Colors().pink : Colors().blue
            cell.distance.text = String(stringInterpolationSegment: placeItems[indexPath.row].distance) + "km"
            let id = placeItems[indexPath.row].placeId
            cell.placeId = id
            cell.sexIcon.image = placeItems[indexPath.row].sexIcon
            cell.backgroundSex.layer.borderColor = placeItems[indexPath.row].majoritySex == "F" ? Colors().pink.CGColor : Colors().blue.CGColor
            cell.typeofPlace = placeItems[indexPath.row].typeofPlace
        }
        
        func cellDataFav() {
            cell.placeName.text = searchArray[indexPath.row].placeName as String?
            cell.city.text = searchArray[indexPath.row].city as String?
            cell.nbUser.text = String(searchArray[indexPath.row].counter)
            cell.averageAge.text = String(searchArray[indexPath.row].averageAge) + " - " + String(searchArray[indexPath.row].averageAge != nil ? searchArray[indexPath.row].averageAge + 1 : 0)
            cell.details.text = String(format: "%.0f", round(searchArray[indexPath.row].pourcentSex))
            cell.details.textColor = searchArray[indexPath.row].majoritySex == "F" ? Colors().pink : Colors().blue
            cell.percent.textColor = searchArray[indexPath.row].majoritySex == "F" ? Colors().pink : Colors().blue
            cell.distance.text = String(stringInterpolationSegment: searchArray[indexPath.row].distance) + "km"
            let id = searchArray[indexPath.row].placeId
            cell.placeId = id
            cell.sexIcon.image = searchArray[indexPath.row].sexIcon
            cell.backgroundSex.layer.borderColor = searchArray[indexPath.row].majoritySex == "F" ? Colors().pink.CGColor : Colors().blue.CGColor
            cell.typeofPlace = searchArray[indexPath.row].typeofPlace
        }
        
        func displayBarOrNightClub(type : String) {
            
            //-- Init settingViewController and variable ageMin ageMax
            let userDefaults = settingViewController.userDefaults
            var displayBar:Bool?
            var displayNightclub:Bool?
            var switchStateBar = userDefaults.boolForKey("SwitchStateBar")
            var switchStateNightclub = userDefaults.boolForKey("SwitchStateNightclub")
            
            //-- Check if SwitchStateBar is set
            if (userDefaults.objectForKey("SwitchStateBar") != nil) {
                displayBar = userDefaults.boolForKey("SwitchStateBar")
            } else {
                displayBar = settingDefault.displayBar
            }
            
            //-- Check if SwitchStateNightclub is set
            if (userDefaults.objectForKey("SwitchStateNightclub") != nil) {
                displayNightclub = switchStateNightclub
            } else {
                displayNightclub = settingDefault.displayNightclub
            }
            
            //-- Set appropiate image for bar or nightclub
            if ((type == "cafe" || type == "bar" || type == "pub") && displayBar! ) {
                cell.iconTableview.image = UIImage(named: "bar-icon")
            } else if(type == "nightclub" && displayNightclub! ) {
                cell.iconTableview.image = UIImage(named: "nightclub-icon")
            } else {
                tableData.rowHeight = 0
                cell.hidden = true
            }
            
        }
        
        //-- Filter by age func
        func filterAge() {
            var ageMin : Double
            var ageMax : Double
            let place = placeItems[indexPath.row]
            let placeAverageAge: Int? = place.averageAge
            
            //-- If userDefault value exist use it, else take the default value
            if (settingViewController.userDefaults.floatForKey("AgeMinValue").isZero && settingViewController.userDefaults.floatForKey("AgeMaxValue").isZero ) {
                ageMin = settingDefault.ageMin
                ageMax = settingDefault.ageMax
            } else {
                ageMin = settingViewController.userDefaults.doubleForKey("AgeMinValue")
                ageMax = settingViewController.userDefaults.doubleForKey("AgeMaxValue")
            }
            
            if place.averageAge != nil {
                if  Double(placeAverageAge!) < ageMin || Double(placeAverageAge!) > ageMax {
                    cell.hidden = true
                    tableData.rowHeight = 0
                }
            }

        }
        
        
        if isFavOn && searchArray.count > indexPath.row {
            let type = searchArray[indexPath.row].typeofPlace as String!
            
            cellDataFav()
            setHeartButtonImage(cell,isFavOn: isFavOn)
            
            //-- Check if users in place (If true elements display else none)
            if searchArray[indexPath.row].counter == nil {
                print("index")
                print(indexPath.row)
                cell.backgroundNbUser.layer.opacity = 0
                cell.backgroundAge.layer.opacity = 0
                cell.backgroundSex.layer.opacity = 0
                tableData.rowHeight = 82
            } else {
                tableData.rowHeight = 153
                cell.backgroundNbUser.layer.opacity = 1
                cell.backgroundAge.layer.opacity = 1
                cell.backgroundSex.layer.opacity = 1
                
            }
            
            //-- Define bar or Nightclub
            displayBarOrNightClub(type)
            return cell
            
        } else {
            let type = placeItems[indexPath.row].typeofPlace as String!
            
            //-- Cell Data MainView
            cellDataMainView()
            setHeartButtonImage(cell,isFavOn: isFavOn)
            
            //-- Check if users in place (If true elements display else none)
            if placeItems[indexPath.row].counter == nil {
                print("index")
                print(indexPath.row)
                cell.backgroundNbUser.layer.opacity = 0
                cell.backgroundAge.layer.opacity = 0
                cell.backgroundSex.layer.opacity = 0
                tableData.rowHeight = 82
            } else {
                tableData.rowHeight = 153
                cell.backgroundNbUser.layer.opacity = 1
                cell.backgroundAge.layer.opacity = 1
                cell.backgroundSex.layer.opacity = 1
            }
            
            displayBarOrNightClub(type)
            filterAge()
        }
            return cell
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (placeItems.count != 0 && !isFavOn) || (searchArray.count != 0 && isFavOn) {
            self.tableData.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            messageLabel.text?.removeAll()
        } else if Reachability.isConnectedToNetwork() == false {
            messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            let mess = "Petit problème d'internet ? ;)"
            
            messageLabel.text = mess
            messageLabel.textColor = Colors().darkGrey
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont(name: "Lato-Regular", size: 18)
            messageLabel.sizeToFit()
            self.tableData.backgroundView = messageLabel
            self.tableData.separatorStyle = UITableViewCellSeparatorStyle.None

        } else {
            //-- Display a message when the table is empty
            messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            var mess = "Aucune données disponible actuellement. Tire pour rafraîchir"
            
            if(searchArray.count == 0 && isFavOn) {
                mess = "Vous n'avez pas encore de favoris !!"
            }
            
            messageLabel.text = mess
            messageLabel.textColor = Colors().darkGrey
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.font = UIFont(name: "Lato-Regular", size: 18)
            messageLabel.sizeToFit()
            
            self.tableData.backgroundView = messageLabel
            self.tableData.separatorStyle = UITableViewCellSeparatorStyle.None
            
        }
        return 1
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        
        guard let tableViewCell = cell as? PlaceCell else { return }
      
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
    }
}

/*
extension MainViewController: UISearchResultsUpdating
{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let isEmpty = searchController.searchBar.text?.isEmpty
        if(isEmpty == false){
            let textSearch = searchController.searchBar.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
            self.searchArray.removeAll()
            QServices.post("POST", params:["object":"object"], url: "https://hadrink.herokuapp.com/search/places/"+textSearch!){
                (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                
                let locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: self.locServices.latitude), "longitude" : String(stringInterpolationSegment: self.locServices.longitude)]
                
                if let reposArray = obj["searchlist"] as? [NSDictionary]  {
                    //println("ReposArray \(reposArray)")
                    
                    for item in reposArray {
                        self.searchArray.append(PlaceItem(json: item, userLocation : locationDictionary))
                        //println("Item \(item)")
                        //print("has Item")
                    }
                    
                }
                //print("reload")
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData.reloadData()
                })
                
            }
        }
    }
}
*/
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
        //print("allow dans l'observer")
        if #available(iOS 9.0, *) {
            self.locationManager.allowsBackgroundLocationUpdates = true
            //    self.locationManager.requestLocation()
            //print(self.locationManager.allowsBackgroundLocationUpdates)
        }
        self.locationManager.startUpdatingLocation()
        //self.locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func WillAppTerminate(notification: NSNotification){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let email: String! = userDefaults.stringForKey("email")
        QServices.post("POST", params:["object":"object"], url: "https://hadrink.herokuapp.com/usercoordinate/users/\(email)/\(self.locationManager.location!.coordinate.latitude)/\(self.locationManager.location!.coordinate.longitude)") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
            //print("dans le post du backgroundeuuuux")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        print("deferredUpdates")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if((locationManager.location) != nil) {
            locServices.latitude = locationManager.location!.coordinate.latitude
            locServices.longitude = locationManager.location!.coordinate.longitude
            let userLatitude = String(stringInterpolationSegment: manager.location!.coordinate.latitude)
            let userLongitude = String(stringInterpolationSegment: manager.location!.coordinate.longitude)
            let userDefaults = NSUserDefaults.standardUserDefaults()
            if UIApplication.sharedApplication().applicationState == .Active {
                userDefaults.setValue("UIApplicationStateActive", forKey: "applicationState")
                locationManager.stopUpdatingLocation()
                
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
                } else {
                    displayBar = settingDefault.displayBar
                }
                
                if (settingViewController.userDefaults.objectForKey("SwitchStateNightclub") != nil) {
                    displayNightclub = settingViewController.userDefault.boolForKey("SwitchStateNightclub")
                } else {
                    displayNightclub = settingDefault.displayNightclub
                }
                
                if (settingViewController.userDefaults.objectForKey("stats_since") != nil) {
                    statsSince = settingViewController.userDefaults.integerForKey("stats_since")
                } else {
                    statsSince = settingDefault.statsSince
                }
                
                //-- Transform to String
                let distanceMaxString = String(stringInterpolationSegment: distanceMax)
                //print("Distance max \(distanceMax)")
                let ageMinString = String(stringInterpolationSegment: ageMin)
                let ageMaxString = String(stringInterpolationSegment: ageMax)
                
                let formatter: NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                
                var friends: AnyObject? = settingViewController.userDefaults.objectForKey("friends")
                
                self.QServices.post("POST", params:["latitude":userLatitude, "longitude": userLongitude, "collection": "places", "age_min" : ageMinString, "age_max" : ageMaxString, "distance_max" : distanceMaxString, "bar" : displayBar, "nightclub" : displayNightclub, "date" : statsSince, "friends" : friends!], url: Urls.urlListPlace) { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
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
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.tableData.reloadData()
                        if ((self.activity.myActivityIndicator) != nil) {
                            self.activity.StopActivityIndicator(self, indicator: self.activity.myActivityIndicator)
                        }
                    })
                }
                
            } else {
                
                //-- This snippet make an app crash when it pass in background
                
                /*NSLog("App is backgrounded. New location is %@", manager.location!)
                let email: String! = userDefaults.stringForKey("email")
                QServices.post("POST", params:["object":"object"], url: "https://hadrink.herokuapp.com/usercoordinate/users/\(email)/\(userLatitude)/\(userLongitude)") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                }
                
                let distance:CLLocationDistance = 200
                let time:NSTimeInterval = 10
                manager.allowDeferredLocationUpdatesUntilTraveled(distance, timeout: time)*/
                
            }
            locationManager = nil
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location" + error.localizedDescription)
    }
}
/*
extension MainViewController: UISearchBarDelegate
{
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.setLogoNavBar()
        self.tableData.reloadData()
    }
}*/


func IsPlaceInCoreData(placeId : String) -> Bool {
    let moContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var isChecked:Bool = false
    let request = NSFetchRequest(entityName: "Place")
    request.includesSubentities = false
    request.returnsObjectsAsFaults = false
    
    //-- Declare predicate and get specific value
    let predicate = NSPredicate(format: "place_id == '\(placeId)'")
    request.predicate = predicate
    
    do {
        let places = try moContext?.executeFetchRequest(request) as! [Place]
        
        for p in places {
            print("ids")
            print(placeId)
            print(p.place_id)
            print(p.place_name)
            if placeId == p.place_id {
                isChecked = p.is_checked as! Bool
            }
        }
    } catch let err as NSError {
        print(err)
    }
    return isChecked
}

func setHeartButtonImage(cell:PlaceCell,isFavOn:Bool)
{
    PFAnalytics.trackEventInBackground("ClickOnHeart", block: nil)
    if (IsPlaceInCoreData(cell.placeId!)/* || isFavOn*/) {
        cell.heartButton.setImage(UIImage(named: "heart-hover"), forState: .Normal)
    }
    else {
        cell.heartButton.setImage(UIImage(named: "heart"), forState: .Normal)
    }
}
