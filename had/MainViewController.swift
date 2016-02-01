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
        
        self.navigationController?.navigationBar.barTintColor = Design().UIColorFromRGB(0x5a74ae)
        self.navigationController?.navigationBar.translucent = false
        
        //-- Observer for background state
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("myObserverMethod:"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
                
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
    
    
    //-- Refresh places
    
    func imageTapped(image: UIGestureRecognizer)
    {
        print("image tapped")
        
        //using sender, we can get the point in respect to the table view
        let tapLocationInView = image.locationInView(self.view)
        let tapLocationInTableView = image.locationInView(self.tableData)
        
        //using the tapLocation, we retrieve the corresponding indexPath
        let indexPath = self.tableData.indexPathForRowAtPoint(tapLocationInTableView)
        
        //finally, we print out the value
        print(indexPath)
        
        //we could even get the cell from the index, too
        let cell = self.tableData.cellForRowAtIndexPath(indexPath!)
        
        var test:String
        test = placeItems[indexPath!.row].placeName!
        print(test)
        print(tapLocationInView)
        
        var profileNameView:UIView = Annotation().createAnnotation(test, postition: tapLocationInView)
        profileNameView.alpha = 0.0
        self.view.addSubview(profileNameView)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            profileNameView.alpha = 0.9
            }, completion: {
                (finished: Bool) -> Void in
                
                // Fade in
                UIView.animateWithDuration(0.5, delay: 2.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    profileNameView.alpha = 0.0
                    }, completion: nil)
        })

    
        //cell.textLabel?.text = "Hello, Cell!"
    }
    
    func setLogoNavBar()
    {
        let SettingsBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: .Plain, target: self, action: "goToSettings:")
        navbar.titleView = UIImageView(image: UIImage(named: "had-title"))
        /*hamburger.image = UIImage(named: "settings")
        hamburger.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        hamburger.action = "goToSettings:"*/
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
        SettingsBarButtonItem.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        //favBarButtonItem.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        favButton.target = self
        favButton.action = "GetFavPlaces:"
        
        /*searchButton.image = UIImage(named: "search-icon")
        searchButton.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        searchButton.target = self
        searchButton.action = "ActivateSearchMode"*/
        
        //        navbar.setLeftBarButtonItems([SettingsBarButtonItem,searchButton], animated: true)
        navbar.setLeftBarButtonItems([SettingsBarButtonItem], animated: true)
        navbar.setRightBarButtonItems([favButton], animated: true)
        //navbar.setRightBarButtonItem(searchButton, animated: true)
        //self.searchArray.removeAll()
        //self.tableData.reloadData()
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
                print("nb fav dans getfavplaces")
                print(places.count)
                
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
                searchArray.append(place)
                print("nbplace saerch")
                print(searchArray.count)*/
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
            self.tableData.addSubview(refreshControl)
            isFavOn = false
            favButton.tintColor = Colors().grey
        }
        self.tableData.reloadData()
    }
    
    //-- Give route place
    @IBAction func routeClicked(sender: AnyObject) {
        
        var indexPath: NSIndexPath
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? PlaceCell {
                    indexPath = tableData.indexPathForCell(cell)!
                    //let indexPath:NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: sender.superview!!.tag)
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
        
        var indexPath: NSIndexPath
        
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? PlaceCell {
                    // text to share
                    
                    indexPath = tableData.indexPathForCell(cell)!
                    
                    var namePlace = placeItems[indexPath.row].placeName
                    var nbUsers = placeItems[indexPath.row].counter

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

class ActivityIndicator: NSObject {
    
    var myActivityIndicator:UIActivityIndicatorView!
    var imageConnexionFailed:UIImageView!
    
    func StartActivityIndicator(obj:UIViewController)
    {
        
        
        if (Reachability.isConnectedToNetwork() == false) {
            imageConnexionFailed = UIImageView(frame: CGRectMake(40, 50, 100, 80))
            imageConnexionFailed.image = UIImage(named: "wifi-icon")
            obj.view.center.y = (obj.view.frame.height / 2) - 100
            imageConnexionFailed.center = obj.view.center
            obj.view.addSubview(imageConnexionFailed)
        } else {
        
        self.myActivityIndicator = UIActivityIndicatorView(frame:CGRectMake(100, 100, 100, 100)) as UIActivityIndicatorView;
        
        self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.myActivityIndicator.center = obj.view.center;
        
        obj.view.addSubview(self.myActivityIndicator);
        
        self.myActivityIndicator.startAnimating();
        //return self.myActivityIndicator;
        }
    }
    
    func StopActivityIndicator(obj:UIViewController,indicator:UIActivityIndicatorView)-> Void
    {
        indicator.removeFromSuperview();
    }
    
    
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

class Annotation {
    func createAnnotation(message : String, postition : CGPoint) -> UIView {
        var labelMessage : UILabel!
        var annotationView : UIView!
        
        let messageSize = message.textSizeWithFont(UIFont(name: "Lato-Italic", size: 14)!, constrainedToSize: CGSize(width: 1000, height: 200))
        
        annotationView = UIView(frame:CGRectMake(0, 0, messageSize + 20, 30))
        labelMessage = UILabel(frame:CGRectMake(0, 0, messageSize, 20))
        labelMessage.font = UIFont(name: "Lato-Italic", size: 14)
        
        labelMessage.text = message
        labelMessage.center = annotationView.center
        annotationView.addSubview(labelMessage as UIView)
        annotationView.center = postition
        annotationView.backgroundColor = UIColor.whiteColor()
        annotationView.layer.shadowColor = UIColor.blackColor().CGColor
        annotationView.layer.shadowOffset = CGSize(width: 1, height: 1)
        annotationView.layer.shadowOpacity = 0.8
        annotationView.layer.cornerRadius = 4
        annotationView.layer.position.x = postition.x + (messageSize / 2)
        annotationView.layer.position.y = postition.y - 10
        
        return annotationView
    }
}