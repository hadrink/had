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
    
            
    var refreshControl = UIRefreshControl()
    var refreshLoadingView : UIView!
    var refreshColorView : UIView!
    var town_background : UIImageView!
    var bottle_spinner : UIImageView!
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    
   
    lazy var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
        }()

    
    var isAnimating = false

    let locServices = LocationServices()
    let QServices = QueryServices()

    //var refreshControl = UIRefreshControl()
    var searchController = UISearchController()
    //@IBOutlet weak var searchBar: UISearchBar!
//    var timer: NSTimer!
    //var refreshControl: UIRefreshControl!
    //var isAnimating = false
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func ActivateSearchMode() {
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchController.searchBar.tintColor = UIColorFromRGB(0xF0F0EF)
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        navigationItem.setLeftBarButtonItem(nil, animated: true)
        navigationItem.setRightBarButtonItems(nil, animated: true)
        //navigationItem.setRightBarButtonItem(nil, animated: true)
        /*let frame = CGRect(x: 0, y: 0, width: navbar.s, height: 44)
        let titleView = UIView(frame: frame)
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.frame = frame
        titleView.addSubview(searchController.searchBar)
        navigationItem.titleView = titleView
        hamburger.enabled = false*/
        //hamburger.image = nil
        
        
        //-- Change color searchBar text and placeholder and set image search icon
        
        let textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColorFromRGB(0xF0F0EF)
        searchController.searchBar.setImage(UIImage(named: "search-icon"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        
        if textFieldInsideSearchBar!.respondsToSelector(Selector("attributedPlaceholder")) {

            let attributeDictSearch = [NSForegroundColorAttributeName: UIColorFromRGB(0xF0F0EF)]
            textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string: "search", attributes: attributeDictSearch)
            
        }
        
        searchController.active = true
        refreshControl.hidden = true
        // Include the search bar within the navigation bar.

        definesPresentationContext = true
        //providesPresentationContextTransitionStyle = false
    }
    
    var searchArray:[PlaceItem] = [PlaceItem](){
        didSet  {self.tableData.reloadData()}
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Friends to user settings
        
        self.setupRefreshControl()



        
        // Initialize the refresh control.
        
        
        
        //refreshControl.backgroundColor = UIColor.purpleColor()
        //refreshControl.tintColor = UIColor.blackColor()
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableData.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib.
        
        // Configure countrySearchController
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        setLogoNavBar()
        
            /********** RevealView Configuration **********/
        
            let revealView = self.revealViewController()
            revealView.frontViewShadowOpacity = 0.0
            //revealView.rearViewRevealWidth = 200
            //revealView.rearViewRevealWidth = view.frame.width
            revealView.rearViewRevealOverdraw = 0
            self.view.addGestureRecognizer(revealView.panGestureRecognizer())
            hamburger.target = revealView
            hamburger.action = "revealToggle:"
        /************* Search Bar ***********/
        //searchBar.delegate = self
            /********** Custom View Design **********/
        
            self.navigationController?.navigationBar.barTintColor = UIColorFromRGB(0x5a74ae)
            self.navigationController?.navigationBar.translucent = false

            locationManager.startUpdatingLocation()
        
            locServices.latitude = locationManager.location!.coordinate.latitude
            locServices.longitude = locationManager.location!.coordinate.longitude
        
           // println("Latitude \(locationManager.location.coordinate.latitude)")
        
                        print("nbplaces")
        
        //-- Observer for background state
        
        UserDataFb().getPicture()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("myObserverMethod:"), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        
    }
    
    /********** Outlets **********/
    
    var hamburger = UIBarButtonItem()
    var favButton = UIBarButtonItem()
    var searchButton = UIBarButtonItem()
    @IBOutlet var tableData: UITableView!
    @IBOutlet var navbar: UINavigationItem!
    @IBOutlet weak var myMap: MKMapView!
    
    /********** Global const & var **********/
    
    var messageLabel:UILabel!

    var data: NSMutableData = NSMutableData()
    var jsonData: NSArray = NSArray()
    var longitude:NSString = ""
    var latitude:NSString = ""
    
    var selectedIndex = -1
    
    func openMapForPlace() {
    }
    
    func getLocationInfo(placemark: CLPlacemark) -> Array<NSString> {
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
        let latitudeDescription = placemark.location!.description
        let scannerLatitude = NSScanner(string:latitudeDescription)
        var scannedLatitude: NSString?
        
        scannerLatitude.scanString("<", intoString:nil)
        
        if scannerLatitude.scanUpToString(",", intoString:&scannedLatitude) {
            latitude = scannedLatitude as! String
            //println("latitude: \(latitude)")
        }
        
        let longitudeDescription = placemark.location!.description
        let scannerLongitude = NSScanner(string:latitudeDescription)
        var scannedLongitude: NSString?
        
        
        if scannerLongitude.scanUpToString(",", intoString:nil) {
            
            scannerLongitude.scanString(",", intoString:nil)
            
            if scannerLongitude.scanUpToString(">", intoString:&scannedLongitude) {
                longitude = scannedLongitude as! String
                //println("longitude: \(longitude)")
            }
            
        }
        
        
        var result = [latitude, longitude]
        locationManager.pausesLocationUpdatesAutomatically = true
        return result
    }
    
    /********** TableView configuration **********/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableData.layoutMargins = UIEdgeInsetsZero
    }
    
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
    
    // Create loop for tableView and convert MKpoint to CGpoint
    /*  func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
    
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    
    var rowData: NSDictionary = self.jsonData[indexPath.row] as NSDictionary
    var idPlace: NSString = rowData["idPlace"] as NSString
    var name: NSString = rowData["NamePlace"] as NSString
    var type: NSString = rowData["Type"] as NSString
    var latitudePlace: NSString = rowData["Latitude"] as NSString
    var longitudePlace: NSString = rowData["Longitude"] as NSString
    
    print(latitudePlace)
    
    cell.detailTextLabel?.text = "\(type),\(latitudePlace),\(longitudePlace)"
    //cell.textLabel.text = name
    cell.backgroundColor = UIColor.clearColor()
    
    var latitudeConversion = (latitudePlace as NSString).floatValue
    var longitudeConversion = (longitudePlace as NSString).floatValue
    
    var latitudeAnnotation:NSNumber = latitudeConversion
    var longitudeAnnotation:NSNumber = longitudeConversion
    
    println("Latitude annotation\(latitudeAnnotation)")
    
    var label = UILabel(frame: CGRectMake(0, 0, 100, 100))
    
    label.textAlignment = NSTextAlignment.Center
    label.text = "1"
    
    
    if(menuItems[indexPath.row].status == "active"){
    cell.backgroundColor = UIColor.whiteColor()
    }else{
    cell.backgroundColor = UIColor.clearColor()
    }
    return cell
    }*/

    
    /********** Refresh places **********/
    func refresh(refreshControl: UIRefreshControl)
    {
        locationManager.startUpdatingLocation()
        //isAnimating = true
        print("refreshing")
        //placeItems = PlaceItem.allPlaceItems()
        if (placeItems.count != 0)
        {
            messageLabel.alpha = 0
        }
        
//        locServices.doQueryPost(&placeItems,tableData: tableData,isRefreshing: true)
        
        self.isAnimating = true
        
        locationManager.startUpdatingLocation()
        
        

        
        // End the refreshing
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        let title:NSString = NSString(format:"Last update: %@", formatter.stringFromDate(NSDate() ))
        let attrsDictionary:NSDictionary  = NSDictionary(object: UIColor.blackColor(), forKey: NSForegroundColorAttributeName)
        
        let attributedTitle:NSAttributedString = NSAttributedString(string: title as String, attributes: attrsDictionary as? [String : AnyObject])
        refreshControl.attributedTitle = attributedTitle;
        
        refreshControl.endRefreshing()
    }
    
    func setLogoNavBar(){
        print("ici")
        let logo = UIImage(named: "had-title@3x")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRectMake(0, 0, 38.66, 44)
        self.navbar.titleView = imageView
        //navigationItem.setLeftBarButtonItem(hamburger, animated: true)
        //navigationItem.setRightBarButtonItem(nil, animated: true)
  //      hamburger.enabled = true
        hamburger.tintColor = UIColorFromRGB(0xF0F0EF)
        hamburger.image = UIImage(named: "hamburger2")
        favButton.image = UIImage(named: "heart-hover@3x")
        favButton.tintColor = UIColorFromRGB(0xF0F0EF)
        searchButton.image = UIImage(named: "search-icon")
        searchButton.tintColor = UIColorFromRGB(0xF0F0EF)
        searchButton.target = self
        searchButton.action = "ActivateSearchMode"
        navbar.setLeftBarButtonItem(hamburger, animated: true)
        navbar.setRightBarButtonItems([favButton,searchButton], animated: true)
    }
}
