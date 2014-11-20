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

class CenterViewController: UIViewController, SidePanelViewControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var creatorLabel: UILabel!
    
    @IBOutlet weak var tableData: UITableView!
    
    var delegate: CenterViewControllerDelegate?
    
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

    // Send latitude, longtitude and get jSon information
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        print("Yo 2")
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                var result = self.getLocationInfo(pm)
                var latitude = result[0]
                var longitude = result[1]
                var dataString = "ACTION=SEARCH&LATITUDE=\(latitude)&LONGITUDE=\(longitude)"
                var xhr = xmlHttpRequest()
                var caramel = xhr.methodPost(dataString)
                
                let location = locations.last as CLLocation
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                //self.mapView.setRegion(region, animated: true)
                
                println(result[0])
                println(result[1])
                
                let data = caramel.dataUsingEncoding(NSUTF8StringEncoding)
                
                var err: NSError
                
                
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                
                /*var null:NSString = jsonResult["places"].objectForKey("<null>") as NSString
                
                if null == null{
                jsonResult["places"].setObject("Not Find", forKey: "<null>")
                }
                
                jsonResult["places"].setObject("Not Find", forKey: "<null>")*/
                
                println(jsonResult)
                
                if jsonResult.count>0 && jsonResult["places"]!.count>0 {
                    var results: NSArray = jsonResult["places"] as NSArray
                    println(results.mutableArrayValueForKey("Adress"))
                    
                    println(results.valueForKeyPath("<null>"))
                    
                    println(jsonResult["places"])
                    
                    self.jsonData = results
                    self.tableData.reloadData()
                }
                
                
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
            latitude = scannedLatitude as String
            println("result: \(latitude)")
        }
        
        let longitudeDescription = placemark.location.description
        let scannerLongitude = NSScanner(string:latitudeDescription)
        var scannedLongitude: NSString?
        
        
        if scannerLongitude.scanUpToString(",", intoString:nil) {
            
            scannerLongitude.scanString(",", intoString:nil)
            
            if scannerLongitude.scanUpToString(">", intoString:&scannedLongitude) {
                longitude = scannedLongitude as String
                println("result: \(longitude)")
            }
            
        }
        
        
        var result = [latitude, longitude]
        return result
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location" + error.localizedDescription)
    }
    
    // Number of Rows depends of count
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        
        return jsonData.count
    }
    
    // Create loop for tableView and convert MKpoint to CGpoint
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        var rowData: NSDictionary = self.jsonData[indexPath.row] as NSDictionary
        var idPlace: NSString = rowData["idPlace"] as NSString
        var latitudePlace: NSString = rowData["Latitude"] as NSString
        var longitudePlace: NSString = rowData["Longitude"] as NSString
        
        print(latitudePlace)
        /*if(rowData["NamePlace"] === "<null>"){
        namePlace = ""
        }
        else{
        namePlace = rowData["NamePlace"] as NSString
        }*/
        //var placeName: NSString = rowData["NamePlace"] as NSString
        cell.detailTextLabel?.text = "\(latitudePlace),\(longitudePlace)"
        cell.textLabel.text = idPlace
        
        
        var latitudeConversion = (latitudePlace as NSString).floatValue
        var longitudeConversion = (longitudePlace as NSString).floatValue
        
        var latitudeAnnotation:NSNumber = latitudeConversion
        var longitudeAnnotation:NSNumber = longitudeConversion
        
        //let coordinatePlaces = CLLocationCoordinate2D(latitude: latitudeAnnotation, longitude: longitudeAnnotation)
        
       // var myPlacesAnnotation = MKPointAnnotation()
        
        //myPlacesAnnotation.coordinate = coordinatePlaces
        
       // myPlacesAnnotation.title = idPlace
        //myPlacesAnnotation.subtitle = "\(latitudePlace),\(longitudePlace)"
        
        println("Latitude annotation\(latitudeAnnotation)")
        
        // self.mapView.addAnnotation(myPlacesAnnotation)
        // self.mapView.selectAnnotation(myPlacesAnnotation, animated: true)
        
        //var annPoint:CGPoint = self.mapView.convertCoordinate(coordinatePlaces, toPointToView: testView)
        //println(annPoint)
        
        var label = UILabel(frame: CGRectMake(0, 0, 100, 100))
        //label.center = annPoint
        
        label.textAlignment = NSTextAlignment.Center
        label.text = "1"
        //ê® testView.addSubview(label)
        
        
        return cell
    }
    
    @IBAction func Menu(sender: AnyObject) {
        if let d = delegate {
            d.toggleLeftPanel?()
        }
    }

    
    func informationSelected(info: Information) {
        titleLabel.text = info.title
        creatorLabel.text = info.creator
        
        if let d = delegate {
            d.collapseSidePanels!()
        }
    }
    
}