//
//  LocationTracker.swift
//  LocationSwing
//
//  Created by Mazhar Biliciler on 19/07/14.
//  Copyright (c) 2014 Mazhar Biliciler. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

let LATITUDE = "latitude"
let LONGITUDE = "longitude"
let ACCURACY = "theAccuracy"

class LocationTracker : NSObject, CLLocationManagerDelegate, UIAlertViewDelegate {
    
    var myLastLocation : CLLocationCoordinate2D?
    var myLastLocationAccuracy : CLLocationAccuracy?
    
    var accountStatus : NSString?
    var authKey : NSString?
    var device : NSString?
    var name : NSString?
    var profilePicURL : NSString?
    var userid : Int?
    
    var shareModel : LocationShareModel?
    
    var myLocation : CLLocationCoordinate2D?
    var myLocationAcuracy : CLLocationAccuracy?
    var myLocationAltitude : CLLocationDistance?
    
    var geotifications = [Geotification]()
    var placeItems = [PlaceItem]()
    
    override init()  {
        super.init()
        self.shareModel = LocationShareModel()
        self.shareModel!.myLocationArray = NSMutableArray()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
    }
    
    class func sharedLocationManager()->CLLocationManager? {
        
        struct Static {
            static var _locationManager : CLLocationManager?
        }
        
        objc_sync_enter(self)
        if Static._locationManager == nil {
            Static._locationManager = CLLocationManager()
            Static._locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        }
        
        objc_sync_exit(self)
        return Static._locationManager!
    }
    
    // MARK: Application in background
    func applicationEnterBackground() {
        let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
        locationManager.pausesLocationUpdatesAutomatically = false
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        self.shareModel!.bgTask = BackgroundTaskManager.sharedBackgroundTaskManager()
        self.shareModel?.bgTask?.beginNewBackgroundTask()
        
    }
    
    
    func restartLocationUpdates() {
        //print("restartLocationUpdates\n")
        
        if self.shareModel?.timer != nil {
            self.shareModel?.timer?.invalidate()
            self.shareModel!.timer = nil
        }
        
        let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        //locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func startLocationTracking() {
        //print("startLocationTracking\n")
        
        if CLLocationManager.locationServicesEnabled() == false {
            //print("locationServicesEnabled false\n")
            let servicesDisabledAlert : UIAlertView = UIAlertView(title: "Location Services Disabled", message: "You currently have all location services for this device disabled", delegate: nil, cancelButtonTitle: "OK")
            servicesDisabledAlert.show()
        } else {
            
            
            let authorizationStatus : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
            if (authorizationStatus == CLAuthorizationStatus.Denied) || (authorizationStatus == CLAuthorizationStatus.Restricted) {
                //print("authorizationStatus failed")
            } else {
                let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
                locationManager.pausesLocationUpdatesAutomatically = false
                if #available(iOS 9.0, *) {
                    locationManager.allowsBackgroundLocationUpdates = true
                } else {
                    // Fallback on earlier versions
                }
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager.distanceFilter = kCLDistanceFilterNone
                //locationManager.startUpdatingLocation()
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func startLocationWhenAppIsKilled() {
        NSLog("startLocationTracking when the app is killed\n")
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue("UIApplicationStateInactive", forKey: "applicationState")
        print(userDefaults.valueForKey("applicationState"))
        
        let authorizationStatus : CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if (authorizationStatus == CLAuthorizationStatus.Denied) || (authorizationStatus == CLAuthorizationStatus.Restricted) {
            NSLog("authorizationStatus failed")
        } else {
            let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
            locationManager.pausesLocationUpdatesAutomatically = false
            if #available(iOS 9.0, *) {
                locationManager.allowsBackgroundLocationUpdates = true
            } else {
                // Fallback on earlier versions
            }
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("locationManager didUpdateLocations\n")
        for (var i : Int = 0; i < locations.count; i++) {
            let newLocation : CLLocation? = locations[i] as CLLocation
            let theLocation : CLLocationCoordinate2D = newLocation!.coordinate
            let theAltitude : CLLocationDistance = newLocation!.altitude
            let theAccuracy : CLLocationAccuracy = newLocation!.horizontalAccuracy
            let locationAge : NSTimeInterval = newLocation!.timestamp.timeIntervalSinceNow
            if locationAge > 30.0 {
                continue
            }
            
            // Select only valid location and also location with good accuracy
            if (newLocation != nil) && (theAccuracy > 0) && (theAccuracy < 2000) && !((theLocation.latitude == 0.0) && (theLocation.longitude == 0.0)) {
                self.myLastLocation = theLocation
                self.myLastLocationAccuracy = theAccuracy
                
                let dict : NSMutableDictionary = NSMutableDictionary()
                dict.setObject(NSNumber(double: theLocation.latitude) as Float, forKey: "latitude")
                dict.setObject(NSNumber(double: theLocation.longitude) as Float, forKey: "longitude")
                dict.setObject(NSNumber(double: theAccuracy) as Float, forKey: "theAccuracy")
                dict.setObject(NSNumber(double: theAltitude), forKey: "theAltitude")
                // Add the vallid location with good accuracy into an array
                // Every 1 minute, I will select the best location based on accuracy and send to server
                self.shareModel!.myLocationArray!.addObject(dict)
            }
        }
        
        // If the timer still valid, return it (Will not run the code below)
        if self.shareModel!.timer != nil {
            return
        }
        
        self.shareModel!.bgTask = BackgroundTaskManager.sharedBackgroundTaskManager()
        self.shareModel!.bgTask!.beginNewBackgroundTask()
        
        // Restart the locationMaanger after 1 minute
        let restartLocationUpdates : Selector = "restartLocationUpdates"
        self.shareModel!.timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: restartLocationUpdates, userInfo: nil, repeats: false)
        
        // Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
        // The location manager will only operate for 10 seconds to save battery
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let appState:NSString = String(userDefaults.valueForKey("applicationState")!)
        if(appState == "UIApplicationStateActive"){
            let stopLocationDelayBy10Seconds : Selector = "stopLocationDelayBy10Seconds"
            let delay  = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: stopLocationDelayBy10Seconds, userInfo: nil, repeats: false)
        }
        
        let notification = UILocalNotification()
        notification.alertBody = appState as String
        notification.soundName = "Default";
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        if(appState == "UIApplicationStateInactive"){
            //updateLocationToServer()
            createRegionsForSignificantChanges()
        }
    }
    
    func createRegionsForSignificantChanges() {
        print("notifTerminte")
        let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
        let notification = UILocalNotification()
        notification.alertBody = String(locationManager.monitoredRegions.count)
        notification.soundName = "Default";
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        if(locationManager.monitoredRegions.count != 0){
            
            for geotification in geotifications{
                stopMonitoringGeotification(geotification)
                removeGeotification(geotification)
            }
        }
        let bestLoc: NSDictionary = getBestLocation()!
        let lat = bestLoc.valueForKey("lat")
        let lon = bestLoc.valueForKey("lon")
        let request = QueryServices()
        request.sendForRegion("https://hadrink.herokuapp.com/closeplaces/places/\(lat!)/\(lon!)/1000/", f: {(result: NSDictionary) -> () in
            let locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: lat), "longitude" : String(stringInterpolationSegment: lon)]
            
            if let reposArray = result["listbar"] as? [NSDictionary]  {
                self.placeItems.removeAll()
                
                
                for item in reposArray {
                    if var placeProperties = item["properties"] as? [String:AnyObject] {
                        if (placeProperties["name"] != nil) {
                            self.placeItems.append(PlaceItem(json: item, userLocation : locationDictionary))
                        }
                    }
                }
            }
            
            notification.alertBody = String(self.placeItems.count)
            notification.soundName = "Default";
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            
        })
        
        for place in placeItems
        {
            if(locationManager.monitoredRegions.count < 20){
                let identifier = NSUUID().UUIDString
                let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: place.placeLatitudeDegrees!, longitude: place.placeLongitudeDegrees!)
                let geotification = Geotification(coordinate: coordinate, radius: 50, identifier: identifier)
                self.geotifications.append(geotification)
                self.startMonitoringGeotification(geotification)
            }
        }
    }
    
    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = true
        //region.notifyOnExit = true
        //region.notifyOnEntry = (geotification.eventType == .OnEntry)
        //region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoringGeotification(geotification: Geotification) {
        // 1
        let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            //showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
            return
        }
        // 2
        /*if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
        //showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self)
        }*/
        // 3
        let region = regionWithGeotification(geotification)
        // 4
        locationManager.startMonitoringForRegion(region)
        //locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func stopMonitoringGeotification(geotification: Geotification) {
        let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == geotification.identifier {
                    locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }
    
    func removeGeotification(geotification: Geotification) {
        if let indexInArray = geotifications.indexOf(geotification) {
            geotifications.removeAtIndex(indexInArray)
        }
    }
    
    func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print(manager.monitoredRegions.count)
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    //MARK: Stop the locationManager
    func stopLocationDelayBy10Seconds() {
        let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
        locationManager.stopMonitoringSignificantLocationChanges()
        print("locationManager stop Updating after 10 seconds\n")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        switch (error.code) {
            
            
        case CLError.Network.rawValue:
            let alert : UIAlertView = UIAlertView(title: "Network Error", message: "Please check your network connection.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            break
        case CLError.Denied.rawValue:
            let alert : UIAlertView = UIAlertView(title: "Network Error", message: "Please check your network connection.", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            break
        default:
            break
        }
        
    }
    
    func stopLocationTracking () {
        print("stopLocationTracking\n")
        
        if self.shareModel!.timer != nil {
            self.shareModel!.timer!.invalidate()
            self.shareModel!.timer = nil
        }
        let locationManager : CLLocationManager = LocationTracker.sharedLocationManager()!
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    // MARK: Update location to server
    func updateLocationToServer() {
        print("updateLocationToServer\n")
        
        // Find the best location from the array based on accuracy
        var myBestLocation : NSMutableDictionary = NSMutableDictionary()
        
        for (var i : Int = 0 ; i < self.shareModel!.myLocationArray!.count ; i++) {
            let currentLocation : NSMutableDictionary = self.shareModel!.myLocationArray!.objectAtIndex(i) as! NSMutableDictionary
            if i == 0 {
                myBestLocation = currentLocation
            } else {
                if (currentLocation.objectForKey(ACCURACY) as! Float) <= (myBestLocation.objectForKey(ACCURACY) as! Float) {
                    myBestLocation = currentLocation
                }
            }
        }
        //print("My Best location \(myBestLocation)\n")
        
        // If the array is 0, get the last location
        // Sometimes due to network issue or unknown reason,
        // you could not get the location during that period, the best you can do is
        // sending the last known location to the server
        
        if self.shareModel!.myLocationArray!.count == 0 {
            //print("Unable to get location, use the last known location\n")
            self.myLocation = self.myLastLocation
            self.myLocationAcuracy = self.myLastLocationAccuracy
        } else {
            let lat : CLLocationDegrees = myBestLocation.objectForKey(LATITUDE) as! CLLocationDegrees
            let lon : CLLocationDegrees = myBestLocation.objectForKey(LONGITUDE) as! CLLocationDegrees
            let theBestLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.myLocation = theBestLocation
            self.myLocationAcuracy = myBestLocation.objectForKey(ACCURACY) as! CLLocationAccuracy!
        }
        //print("Send to server: latitude \(self.myLocation!.latitude) longitude \(self.myLocation!.longitude) accuracy \(self.myLocationAcuracy)\n")
        
        //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
        
        let request = QueryServices()
        request.send("https://hadrink.herokuapp.com/usercoordinate/users/romain.rui10@gmail.com/\(self.myLocation!.latitude)/\(self.myLocation!.longitude)", f: {(result: NSDictionary)-> () in
            //print(result)
        })
        
        
        
        // After sending the location to the server successful,
        // remember to clear the current array with the following code. It is to make sure that you clear up old location in the array
        // and add the new locations from locationManager
        
        self.shareModel!.myLocationArray!.removeAllObjects()
        self.shareModel!.myLocationArray = nil
        self.shareModel!.myLocationArray = NSMutableArray()
    }
    
    func getBestLocation()->NSDictionary? {
        //print("getBestLocationForServer\n")
        
        // Find the best location from the array based on accuracy
        var myBestLocation : NSMutableDictionary = NSMutableDictionary()
        
        for (var i : Int = 0 ; i < self.shareModel!.myLocationArray!.count ; i++) {
            let currentLocation : NSMutableDictionary = self.shareModel!.myLocationArray!.objectAtIndex(i) as!NSMutableDictionary
            if i == 0 {
                myBestLocation = currentLocation
            } else {
                if (currentLocation.objectForKey(ACCURACY) as! Float) <= (myBestLocation.objectForKey(ACCURACY) as! Float) {
                    myBestLocation = currentLocation
                }
            }
        }
        //print("My Best location \(myBestLocation)\n")
        
        // If the array is 0, get the last location
        // Sometimes due to network issue or unknown reason,
        // you could not get the location during that period, the best you can do is
        // sending the last known location to the server
        
        if self.shareModel!.myLocationArray!.count == 0 {
            //print("Unable to get location, use the last known location\n")
            self.myLocation = self.myLastLocation
            self.myLocationAcuracy = self.myLastLocationAccuracy
        } else {
            let lat : CLLocationDegrees = myBestLocation.objectForKey(LATITUDE) as! CLLocationDegrees
            let lon : CLLocationDegrees = myBestLocation.objectForKey(LONGITUDE) as! CLLocationDegrees
            let theBestLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.myLocation = theBestLocation
            
            self.myLocationAcuracy = myBestLocation.objectForKey(ACCURACY) as! CLLocationAccuracy!
        }
        
        let returnType : NSMutableDictionary = NSMutableDictionary()
        returnType.setValue(self.myLocation?.latitude, forKey: "lat")
        returnType.setValue(self.myLocation?.longitude, forKey: "lon")
        returnType.setValue(self.myLocationAcuracy, forKey: "acc")
        
        
        //print("Send to server: latitude \(self.myLocation?.latitude) longitude \(self.myLocation?.longitude) accuracy \(self.myLocationAcuracy)\n")
        
        //TODO: Your code to send the self.myLocation and self.myLocationAccuracy to your server
        
        /*
        
        let request = QueryServices()
        request.send("https://hadrink.herokuapp.com/usercoordinate/users/romain.rui10@gmail.com/\(self.myLocation!.latitude)/\(self.myLocation!.longitude)", f: {(result: NSDictionary)-> () in
        print(result)
        })
        */
        self.shareModel!.myLocationArray!.removeAllObjects()
        self.shareModel!.myLocationArray = nil
        self.shareModel!.myLocationArray = NSMutableArray()
        return returnType
    }
    
}
