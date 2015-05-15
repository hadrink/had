//
//  CenterViewController.swift
//  had
//
//  Created by Chris Degas on 20/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit
import CoreLocation

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController, LeftViewControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableData: UITableView!

    var delegate: CenterViewControllerDelegate?
    var placeItems: Array<PlaceItem>!
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableData.layer.backgroundColor = HadColor.Color.backgroundClearColor.CGColor
    
        //placeItems = PlaceItem.allPlaceItems()
        tableData.reloadData()
    }
    
    let locationManager = CLLocationManager()
    var data: NSMutableData = NSMutableData()
    var jsonData: NSArray = NSArray()
    var longitude:NSString = ""
    var latitude:NSString = ""
    
    @IBAction func myPlacesAround(sender: AnyObject) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = 1.0;
        
        print("Yo")
    }

    func addChildCenterViewController(childController: UIViewController) {
        if (self.view.superview == nil){
            self.addChildViewController(self)
            
            self.view.addSubview(self.view)
        }
    }
    
    // Send latitude, longtitude and get jSon information
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        print("Yo 2")
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                var result = self.getLocationInfo(pm)
                var latitude = result[0]
                var longitude = result[1]
                var dataString = "ACTION=SEARCH&LATITUDE=\(latitude)&LONGITUDE=\(longitude)"
                var xhr = xmlHttpRequest()
                //var caramel = xhr.methodPost(dataString)
                
                let location = locations.last as! CLLocation
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                
                println(result[0])
                println(result[1])
                
                //let data = caramel.dataUsingEncoding(NSUTF8StringEncoding)
                
                var err: NSError
                
                
                //var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                
                //println(jsonResult)
                
               /* if jsonResult.count>0 && jsonResult["places"]!.count>0 {
                    var results: NSArray = jsonResult["places"] as NSArray
                    println(results.mutableArrayValueForKey("Adress"))
                    
                    println(results.valueForKeyPath("<null>"))
                    
                    println(jsonResult["places"])
                    
                    self.jsonData = results
                    self.tableData.reloadData()
                }
                */
                
            }
                
            else {
                println("Problem with the data received from geocoder")
            }
            
        })
    }
    
    // Get location information
    func getLocationInfo(placemark: CLPlacemark) -> Array<NSString> {
    
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
        let latitudeDescription = placemark.location.description
        let scannerLatitude = NSScanner(string:latitudeDescription)
        var scannedLatitude: NSString?
        
        scannerLatitude.scanString("<", intoString:nil)
        
        if scannerLatitude.scanUpToString(",", intoString:&scannedLatitude) {
            latitude = scannedLatitude as! String
            println("result: \(latitude)")
        }
        
        let longitudeDescription = placemark.location.description
        let scannerLongitude = NSScanner(string:latitudeDescription)
        var scannedLongitude: NSString?
        
        
        if scannerLongitude.scanUpToString(",", intoString:nil) {
            
            scannerLongitude.scanString(",", intoString:nil)
            
            if scannerLongitude.scanUpToString(">", intoString:&scannedLongitude) {
                longitude = scannedLongitude as! String
                println("result: \(longitude)")
            }
            
        }
        
        
        var result = [latitude, longitude]
        return result
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaceCell", forIndexPath: indexPath) as! PlaceCell
        //cell.configureForPlaceItem(placeItems[indexPath.row])
        cell.backgroundColor = UIColor.clearColor()
        
        if(selectedIndex == indexPath.row){
            //expand
        }else{
            //close expand
        }
        return cell
    }
    //setRowHeightCell
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        self.tableData.rowHeight = 80
        if(selectedIndex == indexPath.row){
            return 200
        }else{
            return 80
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        tableData.reloadRowsAtIndexPaths(NSArray(object: indexPath) as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    @IBAction func Menu(sender: AnyObject) {
        if let d = delegate {
            d.toggleLeftPanel?()
        }
    }

    func menuItemSelected(item: MenuItem){
        
        if let d = delegate {
            d.collapseSidePanels!()
        }
    }
    
}
