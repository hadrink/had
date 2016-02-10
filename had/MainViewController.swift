//
//  CenterViewTest.swift
//  had
//
//  Created by Rplay on 23/12/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

//
//  SideBarController.swift
//  had
//
//  Created by Chris Degas on 24/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation
import CoreLocation
import MapKit
import CoreData

class MainViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    let model: [[UIColor]] = Design().generateRandomData()
    
    
    
    //-- Global const and var
    
    var hamburger = UIBarButtonItem()
    var favButton = UIBarButtonItem()
    //var searchButton = UIBarButtonItem()
    var messageLabel:UILabel!
    var data: NSMutableData = NSMutableData()
    var jsonData: NSArray = NSArray()
    var longitude:NSString = ""
    var latitude:NSString = ""
    var selectedIndex = -1
    var refreshControl = UIRefreshControl()
    var refreshLoadingView : UIView!
    var refreshColorView : UIView!
    var town_background : UIImageView!
    var bottle_spinner : UIImageView!
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    var isAnimating = false
    var isLocating:Bool = false
    var isFavOn = false
    var nbAlertDuringRefresh = 0
    //var searchController = UISearchController()
    var searchArray:[PlaceItem] = [PlaceItem](){
        didSet  {}
    }
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        //manager.requestAlwaysAuthorization()
        return manager
    }()
    
    
    let locServices = LocationServices()
    let QServices = QueryServices()
    let settingDefault = SettingDefault()
    
    //-- Outlets
    
    @IBOutlet var tableData: UITableView!
    @IBOutlet var navbar: UINavigationItem!
    @IBOutlet weak var myMap: MKMapView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (!isFavOn){
            tableData.reloadData()
        }
        setLogoNavBar()
    }
    
    let activity = ActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.StartActivityIndicator(self)
        
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined || status == CLAuthorizationStatus.Denied){
            locationManager.requestAlwaysAuthorization()
        }
        startLocationManager()
        
        //-- Start Updating Location
        locationManager.startUpdatingLocation()

        self.setupRefreshControl()
        //tableData.reloadData()
        
        self.navigationController?.navigationBar.barTintColor = Design().UIColorFromRGB(0x5a74ae)
        self.navigationController?.navigationBar.translucent = false
        
        //-- Observer for background state
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("myObserverMethod:"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        isFavOn = false
        //getFavPlacesRequest()
        //- Get Picture Facebook
        //UserDataFb().getPicture()
    }
    
    func goToSettings(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableData.layoutMargins = UIEdgeInsetsZero
    }
    
    //-- Table view configuration
    
    var placeItems = [PlaceItem]()
    
    
    //-- Refresh places
       
    func setLogoNavBar() {
        let SettingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .Plain, target: self, action: "goToSettings:")
        navbar.titleView = UIImageView(image: UIImage(named: "had-title"))
        favButton.image = UIImage(named: "heart-hover")
        
        if(isFavOn)
        {
            favButton.tintColor = Colors().pink
            refreshControl.removeFromSuperview()
        }
        else
        {
            favButton.tintColor = Design().UIColorFromRGB(0xF0F0EF)
            self.tableData.addSubview(refreshControl)//active le refresh à la sortie du search
        }
        
        SettingsBarButtonItem.tintColor = Colors().grey
        favButton.target = self
        favButton.action = "GetFavPlaces:"
        
        navbar.setLeftBarButtonItems([SettingsBarButtonItem], animated: true)
        navbar.setRightBarButtonItems([favButton], animated: true)
    }
    
    /*
    * StartUpdatingLocation if the location is deactivate an ui alert is shown
    */
    func startLocationManager(/*isInViewWillAppear:Bool = false*/) -> Bool{
        if(self.locationManager.location != nil){
            print("pause")
            self.locationManager.pausesLocationUpdatesAutomatically = false
            print(self.locationManager.pausesLocationUpdatesAutomatically)
            self.locationManager.startMonitoringSignificantLocationChanges()
            //self.locationManager.startUpdatingLocation()
            self.isLocating = true
        }
        return isLocating
    }
    
    func throwAlert(title: String,message:String,actions:String...){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        
        for action in actions{
            if(action == alertMessage.alertActionSettings){
                alertController.addAction(UIAlertAction(title: action, style: .Default) { (_) -> Void in
                    let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.sharedApplication().openURL(url)
                    }
                    })
            }
            else{
                alertController.addAction(UIAlertAction(title: action, style: .Default,handler: nil))
            }
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func GetFavPlaces(sender:UIButton)
    {
        let displayFav = getFavPlacesRequest()
        if !isFavOn
        {
            PFAnalytics.trackEventInBackground("ClickOnFav", block: nil)
            refreshControl.removeFromSuperview()
            isFavOn = true
            favButton.tintColor = Colors().pink
        }
        else{
            self.tableData.addSubview(refreshControl)
            isFavOn = false
            favButton.tintColor = Colors().grey
        }
        if displayFav {
            self.tableData.reloadData()
        }
    }
    
    func getFavPlacesRequest() -> Bool {
        var displayFav = true
        let moContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        var places = [Place]()
        self.searchArray.removeAll()
        let request = NSFetchRequest(entityName: "Place")
        do {
            
            places = try moContext?.executeFetchRequest(request) as! [Place]
            print("nb fav dans getfavplaces")
            print(places.count)
            
        }
            
        catch let err as NSError {
            
            print(err)
            
        }
        print("nbplace places")
        print(places.count)
        var idArray:Array<String> = Array()
        
        if places.count != 0 {
            displayFav = false
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let dorequest = userDefaults.boolForKey("requestUpdateFav")
            print("dorequest")
            print(dorequest)
            if !dorequest {
                //chercher dans core data
                for  p in places {
                    idArray.append(p.place_id!)
                    
                    let place:PlaceItem = PlaceItem()
                    place.placeId = p.place_id
                    place.placeName = p.place_name
                    print("placename")
                    print(p.place_name)
                    place.city = p.place_city
                    place.averageAge = p.place_average_age?.integerValue
                    place.pourcentSex = p.place_pourcent_sex != nil ? p.place_pourcent_sex?.floatValue : 0.0
                    
                    place.typeofPlace = p.place_type
                    place.counter = p.place_counter?.integerValue
                    place.distance = p.place_distance?.doubleValue
                    place.placeLatitudeDegrees = p.place_latitude?.doubleValue
                    place.placeLongitudeDegrees = p.place_longitude?.doubleValue
                    self.searchArray.append(place)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData.reloadData()
                    
                })
            } else {
                //sinon update avec la requete
                userDefaults.setBool(false, forKey: "requestUpdateFav")
                userDefaults.synchronize()
                for  p in places {
                    idArray.append(p.place_id!)
                }
                let friends = userDefaults.objectForKey("friends")
                var statsSince = 0
                
                if (userDefaults.objectForKey("stats_since") != nil) {
                    statsSince = userDefaults.integerForKey("stats_since")
                } else {
                    statsSince = settingDefault.statsSince
                }
                
                QServices.post("POST", params: ["ids":idArray, "friends":friends!], url: "https://hadrink.herokuapp.com/likeplaces/\(statsSince)", postCompleted:{
                    (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                    if let reposArray = obj["likeplaces"] as? [NSDictionary]  {
                        self.searchArray.removeAll()
                        let locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: self.locServices.latitude), "longitude" : String(stringInterpolationSegment: self.locServices.longitude)]
                        
                        for item in reposArray {
                            if var placeProperties = item["properties"] as? [String:AnyObject] {
                                if (placeProperties["name"] != nil) {
                                    self.searchArray.append(PlaceItem(json: item, userLocation : locationDictionary))
                                }
                            }
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableData.reloadData()
                        
                    })
                })
            }
        } else {
            
            //self.tableData.reloadData()
            /*let notification = UILocalNotification()
            notification.alertBody = "Pas d'ids de place"
            notification.soundName = "Default";
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)*/
        }
        return displayFav
    }
    
    //-- Give route place
    @IBAction func routeClicked(sender: AnyObject) {
        
        PFAnalytics.trackEventInBackground("ClickOnRoute", block: nil)
        
        var indexPath: NSIndexPath
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? PlaceCell {
                    indexPath = tableData.indexPathForCell(cell)!
                    let regionDistance:CLLocationDistance = 10000
                    
                    var latitude = 0.0
                    var longitude = 0.0
                    latitude = placeItems[indexPath.row].placeLatitudeDegrees!
                    longitude = placeItems[indexPath.row].placeLongitudeDegrees!
                    
                    let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                    let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                    
                    let options = [
                        MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
                        MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
                    ]
                    
                    let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                    let mapItem = MKMapItem(placemark: placemark)
                    
                    mapItem.name = placeItems[indexPath.row].placeName
                    mapItem.openInMapsWithLaunchOptions(options)

                }
            }
        }
    }
    
    @IBAction func shareClicked(sender: AnyObject) {
        
        PFAnalytics.trackEventInBackground("ClickOnShare", block: nil)
        
        var indexPath: NSIndexPath
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? PlaceCell {
                    // text to share
                    
                    indexPath = tableData.indexPathForCell(cell)!
                    
                    let namePlace = placeItems[indexPath.row].placeName
                    let nbUsers = placeItems[indexPath.row].counter

                    let textToShare = "\(nbUsers) Hadder sont allés au \(namePlace!). Voir plus d'info sur l'application Had"
        
                    // url to share, if any
                    let urlToShare = NSURL(string: "www.islandtechph.com")
        
                    // place the items to share in an array of type AnyObject
                    let objectsToShare: [AnyObject] = [textToShare, urlToShare!]
        
                    // initialize the controller that will show the share options
                    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
                    // exclude some activities that are irrelevant to your app,
                    // leaving only CopyToPasteboard, Mail, Message
                    if #available(iOS 9.0, *) {
                        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeOpenInIBooks, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypePrint]
                    } else {
                        // Fallback on earlier versions
                    }
        
                    // show the share options view
                    self.presentViewController(activityVC, animated: true, completion: nil)
                }
            }
        }
    }
    //-- Avoid Bounce effect
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let panGesture:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let velocity = panGesture.velocityInView(view)
        
        if velocity.x < 0 {
            return true
        } else {
            return false
        }
        
    }

}
