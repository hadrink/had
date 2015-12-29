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
import CoreLocation
import MapKit
import CoreData

class MainViewController: UIViewController, MKMapViewDelegate {
    
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
        didSet  {self.tableData.reloadData()}
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
        setLogoNavBar()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.NotDetermined || status == CLAuthorizationStatus.Denied){
            locationManager.requestAlwaysAuthorization()
        }
        startLocationManager()
        self.setupRefreshControl()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configure countrySearchController
        
        
        //-- Reveal view configuration
        
        self.navigationController?.navigationBar.barTintColor = Design().UIColorFromRGB(0x5a74ae)
        self.navigationController?.navigationBar.translucent = false
        
        //-- Observer for background state
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("myObserverMethod:"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        
        //- Get Picture Facebook
        UserDataFb().getPicture()
    }
    
    func goToSettings(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableData.layoutMargins = UIEdgeInsetsZero
    }
    /*
    func ActivateSearchMode() {
    
    searchController = UISearchController(searchResultsController: nil)
    let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
    searchController.searchBar.becomeFirstResponder()
    searchController.searchResultsUpdater = self
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.delegate = self
    searchController.searchBar.searchBarStyle = .Minimal
    searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
    searchController.searchBar.tintColor = Design().UIColorFromRGB(0xF0F0EF)
    searchController.dimsBackgroundDuringPresentation = false
    
    navigationItem.titleView = searchController.searchBar
    navigationItem.setLeftBarButtonItem(nil, animated: true)
    navigationItem.setRightBarButtonItems(nil, animated: true)
    
    //-- Change color searchBar text and placeholder and set image search icon
    textFieldInsideSearchBar?.textColor = Design().UIColorFromRGB(0xF0F0EF)
    searchController.searchBar.setImage(UIImage(named: "search-icon"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
    
    if textFieldInsideSearchBar!.respondsToSelector(Selector("attributedPlaceholder")) {
    let attributeDictSearch = [NSForegroundColorAttributeName: Design().UIColorFromRGB(0xF0F0EF)]
    textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string: "search", attributes: attributeDictSearch)
    }
    
    searchController.active = true
    refreshControl.removeFromSuperview()//deactive le refrsh pendant le search
    
    definesPresentationContext = true
    }
    */
    //-- Table view configuration
    
    var placeItems = [PlaceItem]()
    
    func routeButtonClicked(sender:UIButton) {
        
        let indexPath:NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: sender.superview!.tag)
        let regionDistance:CLLocationDistance = 10000
        
        var latitude = 0.0
        var longitude = 0.0
        print("itineraire")
        /*        print(self.searchController.active)
        if !self.searchController.active
        {*/
        latitude = placeItems[indexPath.row].placeLatitudeDegrees!
        longitude = placeItems[indexPath.row].placeLongitudeDegrees!
        /*      }
        else
        {
        latitude = searchArray[indexPath.row].placeLatitudeDegrees!
        longitude = searchArray[indexPath.row].placeLongitudeDegrees!
        }
        */
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        /*        if !self.searchController.active
        {*/
        mapItem.name = placeItems[indexPath.row].placeName
        /*        }
        else
        {
        mapItem.name = searchArray[indexPath.row].placeName
        }*/
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    
    //-- Refresh places
    
    func setLogoNavBar()
    {
        let SettingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .Plain, target: self, action: "goToSettings:")
        navbar.titleView = UIImageView(image: UIImage(named: "had-title"))
        /*hamburger.image = UIImage(named: "settings")
        hamburger.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        hamburger.action = "goToSettings:"*/
        favButton.image = UIImage(named: "heart-hover")
        SettingsBarButtonItem.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        //favBarButtonItem.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        favButton.target = self
        favButton.action = "GetFavPlaces:"
        favButton.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        /*searchButton.image = UIImage(named: "search-icon")
        searchButton.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        searchButton.target = self
        searchButton.action = "ActivateSearchMode"*/
        self.tableData.addSubview(refreshControl)//active le refresh à la sortie du search
        //        navbar.setLeftBarButtonItems([SettingsBarButtonItem,searchButton], animated: true)
        navbar.setLeftBarButtonItems([SettingsBarButtonItem], animated: true)
        navbar.setRightBarButtonItems([favButton], animated: true)
        //navbar.setRightBarButtonItem(searchButton, animated: true)
        self.searchArray.removeAll()
        
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
        /*else{
        throwAlert(alertMessage.titleAlertLocationManagerOff,message: alertMessage.messageAlertLocationManagerOff,
        actions: alertMessage.alertActionOK,alertMessage.alertActionSettings)
        }*/
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
        //alertController.addAction(UIAlertAction(title: "Réglages", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func GetFavPlaces(sender:UIButton)
    {
        if !isFavOn
        {
            refreshControl.removeFromSuperview()
            isFavOn = true
            favButton.tintColor = Colors().pink
            let moContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
            var places = [Place]()
            self.searchArray.removeAll()
            let request = NSFetchRequest(entityName: "Place")
            do {
                
                places = try moContext?.executeFetchRequest(request) as! [Place]
                
            }
                
            catch let err as NSError {
                
                print(err)
                
            }
            print("nbplace places")
            print(places.count)
            var idArray:Array<String> = Array()
            for  p in places {
                idArray.append(p.place_id!)
                /*let place:PlaceItem = PlaceItem()
                place.placeId = p.place_id
                place.placeName = p.place_name
                print("placename")
                print(p.place_name)
                place.city = p.place_city
                place.averageAge = p.place_average_age?.integerValue
                place.pourcentSex = p.place_pourcent_sex?.floatValue
                place.typeofPlace = p.place_type
                place.counter = p.place_counter?.integerValue
                place.distance = p.place_distance?.doubleValue
                place.placeLatitudeDegrees = p.place_latitude?.doubleValue
                place.placeLongitudeDegrees = p.place_longitude?.doubleValue
                searchArray.append(place)*/
                print("nbplace saerch")
                print(searchArray.count)
            }
            if idArray.count != 0
            {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                var statsSince = 0
                if (userDefaults.objectForKey("stats_since") != nil) {
                    statsSince = userDefaults.integerForKey("stats_since")
                } else {
                    statsSince = settingDefault.statsSince
                }
                QServices.post("POST", params: ["ids":idArray], url: "https://hadrink.herokuapp.com/likeplaces/\(statsSince)", postCompleted: { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
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
                    print("Mon object listfav\(obj)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.tableData.reloadData()
                        
                    })
                    }
                )
            }
            else
            {
                let notification = UILocalNotification()
                notification.alertBody = "Pas d'ids de place"
                notification.soundName = "Default";
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            }
        }
        else{
            isFavOn = false
            favButton.tintColor = Colors().grey
        }
        self.tableData.reloadData()
    }
}
