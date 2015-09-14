//
//  PlaceItem.swift
//  had
//
//  Created by Chris Degas on 27/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceItem : CLLocationManager{
    
    var locationManager = CLLocationManager()
    
    // Global variables for cells

    var placeName: String?
    var city : String?
    var counter: String!
    var averageAge: Int!
    var pourcentFemale:Float!
    var distance : Double!
    var placeLatitudeDegrees : CLLocationDegrees?
    var placeLongitudeDegrees : CLLocationDegrees?
    var typeofPlace : String?
    
    // Init variables
    
    required init (json : NSDictionary, userLocation : NSDictionary) {
        
        // Init for place name and counter
        
        if var placeProperties = json["properties"] as? [String:AnyObject] {
            placeName = placeProperties["name"] as? String
            typeofPlace = placeProperties["amenity"] as? String
        }
        
        println(typeofPlace)
        
        counter = String(stringInterpolationSegment: json["counter"] as! Int!)
        
        // Init for location info
        
        var userLatitude = userLocation["latitude"] as? NSString
        var userLongitude = userLocation["longitude"] as? NSString
        var userLatitudeDegrees:CLLocationDegrees = userLatitude!.doubleValue
        var userLongitudeDegrees:CLLocationDegrees = userLongitude!.doubleValue
        var usersVisitedInfo: NSDictionary = NSDictionary()
        
        if var placeLocation = json["loc"] as? [String:AnyObject]
        {
            var placeCoordinate = placeLocation["coordinates"]! as? NSArray
            var placeLongitude = placeCoordinate!.firstObject as! NSObject
            var placeLatitude = placeCoordinate!.lastObject as! NSObject
            placeLatitudeDegrees = placeLatitude as? Double
            placeLongitudeDegrees = placeLongitude as? Double
            
            var placeCoordinatesDegrees = CLLocation(latitude: placeLatitudeDegrees!, longitude: placeLongitudeDegrees!)
            var userCoordinatesDegrees = CLLocation(latitude: userLatitudeDegrees, longitude: userLongitudeDegrees)
            
            var distanceInMeters = placeCoordinatesDegrees.distanceFromLocation(userCoordinatesDegrees)
            
            func roundToPlaces(value:Double, places:Int) -> Double {
                var divisor = pow(10.0, Double(places))
                return round(value * divisor) / divisor
            }
            
            distance = roundToPlaces(distanceInMeters / 1000, 1)
            
        }
        
        // Init for address data
        
        if var addressValues = json["properties"] as? [String:AnyObject] {
            city = (addressValues["city"] as? String)
        }
        
        // Init for users data
        
        if var usersvisited = json["usersvisited"] as? [NSDictionary] {
            
            var cumul:Int = 0
            var count:Int = 0
            var sexArray : [String] = []
            
            for uservisited in usersvisited {
                var age:String = uservisited.objectForKey("age") as! String
                var sex:String = uservisited.objectForKey("sex") as! String
                var ageInt = age.toInt()
                
                sexArray.append(sex)
                
                count = usersvisited.count
                cumul += ageInt!
                
            }
            
            var sexCount = sexArray.count
            var sexFemaleCount = sexArray.filter {
                $0 == "F"
            }.count
            
            pourcentFemale = (Float(sexFemaleCount) / Float(sexCount))*100
            averageAge = cumul / count
            
        }
        
        
    }
    
}

