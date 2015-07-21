//
//  locationServices.swift
//  had
//
//  Created by chrisdegas on 02/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class LocationServices {
    
    var latitude:CLLocationDegrees = 0.0
    var longitude:CLLocationDegrees = 0.0
    
    func mapsHandler(indexPath:NSIndexPath, placeItems:[PlaceItem], searchArray : [PlaceItem],
                    placesSearchController:UISearchController){
        //        let indexPath:NSIndexPath = NSIndexPath(forRow: sender.tag, inSection: sender.superview!.tag)
        let regionDistance:CLLocationDistance = 10000
        
        var latitude = 0.0
        var longitude = 0.0
        println("itineraire")
        println(placesSearchController.active)
        if !placesSearchController.active
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
        
        if !placesSearchController.active
        {
            mapItem.name = placeItems[indexPath.row].placeName
        }
        else
        {
            mapItem.name = searchArray[indexPath.row].placeName
        }

        mapItem.openInMapsWithLaunchOptions(options)
    }
    
    /*func doQueryPost(inout placeItems:[PlaceItem] , tableData : UITableView, isRefreshing : Bool)
    {
        var QServices = QueryServices()
        QServices.post(["object":"object"], url: "http://151.80.128.136:3000/places/\(latitude)/\(longitude)/10") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
            //var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
            
            var locationDictionary:NSDictionary = ["latitude" : String(stringInterpolationSegment: self.latitude), "longitude" : String(stringInterpolationSegment: self.longitude)]
            
            if let reposArray = obj["listbar"] as? [NSDictionary]  {
                //println("ReposArray \(reposArray)")
                println("RefreshhhYouhou")
                if isRefreshing{
                    placeItems.removeAll()
                }
                for item in reposArray {
                    placeItems.append(PlaceItem(json: item, userLocation : locationDictionary))
                    //println("Item \(item)")
                }
                println(placeItems.count)
                //println("place item \(self.placeItems)")
            }
            println("Mon object \(obj)")
            
            dispatch_async(dispatch_get_main_queue(), {
                
                tableData.reloadData()
                
            })
        }
        
    }*/
}
    