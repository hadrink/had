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
    
    func mapsHandler(indexPath:NSIndexPath, placeItems:[PlaceItem], searchArray : [PlaceItem], placesSearchController:UISearchController){
        
        let regionDistance:CLLocationDistance = 10000
        var latitude = 0.0
        var longitude = 0.0
        
        
        if !placesSearchController.active {
            
            latitude = placeItems[indexPath.row].placeLatitudeDegrees!
            longitude = placeItems[indexPath.row].placeLongitudeDegrees!
            
        } else {
            
            latitude = searchArray[indexPath.row].placeLatitudeDegrees!
            longitude = searchArray[indexPath.row].placeLongitudeDegrees!
        }
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        if !placesSearchController.active {
            
            mapItem.name = placeItems[indexPath.row].placeName
            
        } else {
            
            mapItem.name = searchArray[indexPath.row].placeName
            
        }

        mapItem.openInMapsWithLaunchOptions(options)
        
    }
    
}
    