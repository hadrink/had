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

class MainViewController: UIViewController, MKMapViewDelegate {
    
    //-- Global const and var
    
    var hamburger = UIBarButtonItem()
    //var favButton = UIBarButtonItem()
    var searchButton = UIBarButtonItem()
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
    var nbAlertDuringRefresh = 0
    var searchController = UISearchController()
    var searchArray:[PlaceItem] = [PlaceItem](){
        didSet  {self.tableData.reloadData()}
    }
    
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
        }()
    
    let locServices = LocationServices()
    let QServices = QueryServices()
    let settingDefault = SettingDefault()
    
    
    //-- Outlets
    
    @IBOutlet var tableData: UITableView!
    @IBOutlet var navbar: UINavigationItem!
    @IBOutlet weak var myMap: MKMapView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealView = self.revealViewController()
        
        // Set Friends to user settings
        startLocationManager()
        self.setupRefreshControl()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configure countrySearchController
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        setLogoNavBar()
        
        //-- Reveal view configuration
        
        revealView.frontViewShadowOpacity = 1.0
        revealView.rearViewRevealOverdraw = 0
        self.view.addGestureRecognizer(revealView.panGestureRecognizer())
        hamburger.target = revealView
        hamburger.action = "revealToggle:"
        self.navigationController?.navigationBar.barTintColor = Design().UIColorFromRGB(0x5a74ae)
        self.navigationController?.navigationBar.translucent = false
        
        //-- Observer for background state
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("myObserverMethod:"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        //- Get Picture Facebook
        
        UserDataFb().getPicture()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableData.layoutMargins = UIEdgeInsetsZero
    }
    
    func ActivateSearchMode() {
        
        let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        searchController.searchBar.becomeFirstResponder()
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
        searchController.searchBar.setImage(UIImage(named: "search-icon@3x"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        
        if textFieldInsideSearchBar!.respondsToSelector(Selector("attributedPlaceholder")) {
            let attributeDictSearch = [NSForegroundColorAttributeName: Design().UIColorFromRGB(0xF0F0EF)]
            textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string: "search", attributes: attributeDictSearch)
        }
        
        searchController.active = true
        refreshControl.removeFromSuperview()//deactive le refrsh pendant le search
        
        definesPresentationContext = true
        
    }
    
    //-- Table view configuration
    
    var placeItems = [PlaceItem]()
    
    func routeButtonClicked(sender:UIButton) {
        
        let indexPath:NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: sender.superview!.tag)
        let regionDistance:CLLocationDistance = 10000
        
        var latitude = 0.0
        var longitude = 0.0
        print("itineraire")
        print(self.searchController.active)
        if !self.searchController.active
        {
            latitude = placeItems[indexPath.row].placeLatitudeDegrees!
            longitude = placeItems[indexPath.row].placeLongitudeDegrees!
        }
        else
        {
            latitude = searchArray[indexPath.row].placeLatitudeDegrees!
            longitude = searchArray[indexPath.row].placeLongitudeDegrees!
        }
        
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        if !self.searchController.active
        {
            mapItem.name = placeItems[indexPath.row].placeName
        }
        else
        {
            mapItem.name = searchArray[indexPath.row].placeName
        }
        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    
    //-- Refresh places
    
   /* func refresh(refreshControl: UIRefreshControl) {
        
        /*let formatter:NSDateFormatter = NSDateFormatter()
        let attrsDictionary:NSDictionary  = NSDictionary(object: UIColor.blackColor(), forKey: NSForegroundColorAttributeName)
        formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")*/
        
        print("refreshing")
        
        if (placeItems.count != 0) {
            messageLabel.alpha = 0
        }
        
        //self.isAnimating = true
        
        startLocationManager()
        
        // End the refreshing
        
        refreshControl.endRefreshing()
    }*/
    
    func setLogoNavBar(){
        let logo = UIImage(named: "had-title@3x")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRectMake(0, 0, 38.66, 44)
        self.navbar.titleView = imageView
        
        hamburger.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        hamburger.image = UIImage(named: "setting@3x")
        
        //favButton.image = UIImage(named: "heart-hover@3x")
        //favButton.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        
        searchButton.image = UIImage(named: "search-icon")
        searchButton.tintColor = Design().UIColorFromRGB(0xF0F0EF)
        searchButton.target = self
        searchButton.action = "ActivateSearchMode"
        self.tableData.addSubview(refreshControl)//active le refresh à la sortie du search
        navbar.setLeftBarButtonItem(hamburger, animated: true)
        navbar.setRightBarButtonItem(searchButton, animated: true)
        self.searchArray.removeAll()
        
    }
    /*
    * StartUpdatingLocation if the location is deactivate an ui alert is shown
    */
    func startLocationManager() -> Bool{
        var isLocating:Bool = false
        if(locationManager.location != nil){
            locationManager.startUpdatingLocation()
            isLocating = true
        }
        else
        {
            let alertController = UIAlertController(title: "Service de Localisation Désactivé", message:
                "Merci d'activer le service de localisation dans les Réglages !", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            alertController.addAction(UIAlertAction(title: "Réglages", style: .Default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            //alertController.addAction(UIAlertAction(title: "Réglages", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        return isLocating
    }
}
