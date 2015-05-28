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


class MainViewController:UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource  {
     override func viewDidLoad() {
        super.viewDidLoad()
        
       /* // Initialize the refresh control.
        var refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.whiteColor()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableData.addSubview(refreshControl)
        // Do any additional setup after loading the view, typically from a nib. */
        
            /********** RevealView Configuration **********/
        
            let revealView = self.revealViewController()
            revealView.frontViewShadowOpacity = 0.0
            revealView.rearViewRevealWidth = 80
            self.view.addGestureRecognizer(revealView.panGestureRecognizer())
            hamburger.target = revealView
            hamburger.action = "revealToggle:"
        
        
            /********** Custom View Design **********/
        
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 74/255, green: 123/255, blue: 195/255, alpha: 1)
            self.navigationController?.navigationBar.translucent = false
        
        
            let logo = UIImage(named: "had-title@3x")
            let imageView = UIImageView(image:logo)
            imageView.frame = CGRectMake(0, 0, 38.66, 44)
            self.navbar.titleView = imageView
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        
        
            //PlaceItem.allPlaceItems()
        
        
            /********** Init variables **********/
        
            placeItems = PlaceItem.allPlaceItems()
            //placeItems = []
        
        
        /********** Get BarList ************/
        
        

        
    }
    
    /********** Outlets **********/
    
    @IBOutlet weak var hamburger: UIBarButtonItem!
    @IBOutlet var tableData: UITableView!
    @IBOutlet var navbar: UINavigationItem!
    /********** Override function **********/
    
    override func  prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    /********** Global const & var **********/
    
    var messageLabel:UILabel!
    var placeItems: Array<PlaceItem>!
    let locationManager = CLLocationManager()
    var data: NSMutableData = NSMutableData()
    var jsonData: NSArray = NSArray()
    var longitude:NSString = ""
    var latitude:NSString = ""
    
    var selectedIndex = -1
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                var latLng = self.getLocationInfo(pm)
                println(latLng[0])
                println(latLng[1])
                var methodePost = xmlHttpRequest()
                
                methodePost.post(["object":"object"], url: "http://151.80.128.136:3000/places/\(latLng[0])/\(latLng[1])/10") { (succeeded: Bool, msg: String) -> () in
                    var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                    
                    /*if(succeeded) {
                        alert.title = "Success!"
                        alert.message = msg
                    }
                    else {
                        alert.title = "Login Problem"
                        alert.message = "Wrong username or password."
                        alert.addButtonWithTitle("Foiled Again!")
                    }*/
                    
                    // Move to the UI thread
                    /*dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Show the alert
                        //alert.show()
                    })*/
                }
                
                
                
            } else {
                println("Problem with the data received from geocoder")
            }
            
        })
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
            println("latitude: \(latitude)")
        }
        
        let longitudeDescription = placemark.location.description
        let scannerLongitude = NSScanner(string:latitudeDescription)
        var scannedLongitude: NSString?
        
        
        if scannerLongitude.scanUpToString(",", intoString:nil) {
            
            scannerLongitude.scanString(",", intoString:nil)
            
            if scannerLongitude.scanUpToString(">", intoString:&scannedLongitude) {
                longitude = scannedLongitude as! String
                println("longitude: \(longitude)")
            }
            
        }
        
        
        var result = [latitude, longitude]
        locationManager.pausesLocationUpdatesAutomatically = true
        return result
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
    
    /********** TableView configuration **********/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableData.layoutMargins = UIEdgeInsetsZero
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         println(placeItems)
        return placeItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath: indexPath) as! PlaceCell
        cell.layoutMargins = UIEdgeInsetsZero
        cell.configureForPlaceItem(placeItems[indexPath.row])
        //cell.backgroundColor = UIColor.clearColor()
        
        if (indexPath.row%2 == 1){
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
        
        return cell
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
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
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
    }

    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        if placeItems.count != 0
        {
            self.tableData.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            return 1;
        }
        else
        {
            // Display a message when the table is empty
            messageLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            messageLabel.text = "No data is currently available. Please pull down to refresh."
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
    
    
    /********** Refresh places **********/
    func refresh(refreshControl: UIRefreshControl)
    {
        println("refreshing")
        placeItems = PlaceItem.allPlaceItems()
        if (placeItems.count != 0)
        {
            messageLabel.alpha = 0
        }
        
        self.tableData.reloadData()
        
        // End the refreshing
        var formatter:NSDateFormatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        var title:NSString = NSString(format:"Last update: %@", formatter.stringFromDate(NSDate() ))
        var attrsDictionary:NSDictionary  = NSDictionary(object: UIColor.blackColor(), forKey: NSForegroundColorAttributeName)
        
        var attributedTitle:NSAttributedString = NSAttributedString(string: title as String, attributes: attrsDictionary as [NSObject : AnyObject])
        refreshControl.attributedTitle = attributedTitle;
        
        refreshControl.endRefreshing()
    }
    
}
