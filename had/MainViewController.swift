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
    var compass_background : UIImageView!
    var compass_spinner : UIImageView!
    
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    
    
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
        compass_background = UIImageView(image: UIImage(named: "pull-to-refresh-bg@3x"))
        //compass_background.frame.size.width = 375
        //compass_background.frame.size.height = 10
        
        self.compass_spinner = UIImageView(image: UIImage(named: "bottle-spin@3x"))
        self.compass_spinner.frame.size = CGSize(width: 42, height: 42)
        
        
        // Add the graphics to the loading view
        self.refreshLoadingView.addSubview(self.compass_background)
        self.refreshLoadingView.addSubview(self.compass_spinner)
        
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
        var compassHeight = self.compass_background.bounds.size.height + 120;
        var compassHeightHalf = compassHeight / 2.0;
        
        var compassWidth = self.compass_background.bounds.size.width;
        var compassWidthHalf = compassWidth / 2.0;
        
        var spinnerHeight = self.compass_spinner.bounds.size.height;
        var spinnerHeightHalf = spinnerHeight / 2.0;
        
        var spinnerWidth = self.compass_spinner.bounds.size.width;
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
        var compassFrame = self.compass_background.frame;
        compassFrame.origin.x = compassX;
        compassFrame.origin.y = compassY;
        
        var spinnerFrame = self.compass_spinner.frame;
        spinnerFrame.origin.x = spinnerX;
        spinnerFrame.origin.y = spinnerY;
        
        self.compass_background.frame = compassFrame;
        self.compass_spinner.frame = spinnerFrame;
        
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
                self.compass_spinner.transform = CGAffineTransformRotate(self.compass_spinner.transform, CGFloat(M_PI_2))
                
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
        
        var textFieldInsideSearchBar = searchController.searchBar.valueForKey("searchField") as? UITextField
        
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
        
            locServices.latitude = 48.7809894//locationManager.location.coordinate.latitude
            locServices.longitude = 2.2066908//locationManager.location.coordinate.longitude
        
           // println("Latitude \(locationManager.location.coordinate.latitude)")
        
                        println("nbplaces")
        
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
        
        let latitudeDescription = placemark.location.description
        let scannerLatitude = NSScanner(string:latitudeDescription)
        var scannedLatitude: NSString?
        
        scannerLatitude.scanString("<", intoString:nil)
        
        if scannerLatitude.scanUpToString(",", intoString:&scannedLatitude) {
            latitude = scannedLatitude as! String
            //println("latitude: \(latitude)")
        }
        
        let longitudeDescription = placemark.location.description
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
        println("itineraire")
        println(self.searchController.active)
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

        var coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
       
        var options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        
        var placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        var mapItem = MKMapItem(placemark: placemark)
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
        //isAnimating = true
        println("refreshing")
        //placeItems = PlaceItem.allPlaceItems()
        if (placeItems.count != 0)
        {
            messageLabel.alpha = 0
        }
        
//        locServices.doQueryPost(&placeItems,tableData: tableData,isRefreshing: true)
        
        self.isAnimating = true
        
        locationManager.startUpdatingLocation()
        
        

        
        // End the refreshing
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        var title:NSString = NSString(format:"Last update: %@", formatter.stringFromDate(NSDate() ))
        var attrsDictionary:NSDictionary  = NSDictionary(object: UIColor.blackColor(), forKey: NSForegroundColorAttributeName)
        
        var attributedTitle:NSAttributedString = NSAttributedString(string: title as String, attributes: attrsDictionary as [NSObject : AnyObject])
        refreshControl.attributedTitle = attributedTitle;
        
        refreshControl.endRefreshing()
    }
    
    func setLogoNavBar(){
        println("ici")
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
