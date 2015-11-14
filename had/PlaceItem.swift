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
    
    var placeId: String?
    var placeName: String?
    var city : String?
    var counter: Int!
    var averageAge: Int!
    var pourcentSex:Float!
    var distance : Double!
    var placeLatitudeDegrees : CLLocationDegrees?
    var placeLongitudeDegrees : CLLocationDegrees?
    var typeofPlace : String?
    var friends: Array<String>?
    var sexIcon : UIImage?
    var majoritySex : String?
    
    // Init variables
    
     init (json : NSDictionary, userLocation : NSDictionary) {
        
        // Init for place name and counter
        print(json)
        
        placeId = json["_id"] as? String
        
        if var placeProperties = json["properties"] as? [String:AnyObject] {
            placeName = placeProperties["name"] as? String
            typeofPlace = placeProperties["amenity"] as? String
        }
        
        // Get friends visited place
        
        friends = json["friends"] as? Array<String>
        
        print("Friends visited \(friends)")
        
        print(typeofPlace)
        
        //counter = String(stringInterpolationSegment: json["counter"] as! Int!)
        
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
                let divisor = pow(10.0, Double(places))
                return round(value * divisor) / divisor
            }
            
            distance = roundToPlaces(distanceInMeters / 1000, places: 1)
            
        }
        
        // Init for address data
        
        if var addressValues = json["properties"] as? [String:AnyObject] {
            city = (addressValues["city"] as? String)
        }
        
        // Init for users data
        
        var cumul:Int = 0
        var count:Int = 0
        var sexArray : [String] = []
        
        if let usersvisited = json["visitors"] as? [NSDictionary] {
            
            print("visitorsss")
            print(usersvisited)
            
            for uservisited in usersvisited {
                let age:String = uservisited["age"] as! String
                let sex:String = uservisited["sex"] as! String
                print("age")
                print(sex)
                print(age)
                let ageInt = Int(age)
                
                sexArray.append(sex)
                
                count = usersvisited.count
                cumul += ageInt!
                
            }
            
            let sexCount = sexArray.count
            let sexFemaleCount = sexArray.filter {
                $0 == "F"
            }.count
            
            //-- Calc average male and female
            let pourcentFemale = (Float(sexFemaleCount) / Float(sexCount))*100
            let pourcentMale = 100 - pourcentFemale
            
            //-- Check if male or female is in majority and return values in function
            if pourcentFemale > 50 {
                pourcentSex = pourcentFemale
                sexIcon = UIImage(named: "sexicon-female")
                majoritySex = "F"
            } else {
                pourcentSex = pourcentMale
                sexIcon = UIImage(named: "sexicon-male")
                majoritySex = "M"
            }
            
        }
        
        if cumul != 0 && count != 0 {
            counter = count
            averageAge = cumul / count
        }
        
    }
    
    override init()
    {
        
    }
    /*
    required init (json : NSDictionary) {
        
        // Init for place name and counter
        
        if var placeProperties = json["properties"] as? [String:AnyObject] {
            placeName = placeProperties["name"] as? String
            typeofPlace = placeProperties["amenity"] as? String
        }
        
        print(typeofPlace)
        
        counter = String(stringInterpolationSegment: json["counter"] as! Int!)
        
        // Init for location info
        
        var usersVisitedInfo: NSDictionary = NSDictionary()
        
        if var placeLocation = json["loc"] as? [String:AnyObject]
        {
            var placeCoordinate = placeLocation["coordinates"]! as? NSArray
            var placeLongitude = placeCoordinate!.firstObject as! NSObject
            var placeLatitude = placeCoordinate!.lastObject as! NSObject
            placeLatitudeDegrees = placeLatitude as? Double
            placeLongitudeDegrees = placeLongitude as? Double
            
            var placeCoordinatesDegrees = CLLocation(latitude: placeLatitudeDegrees!, longitude: placeLongitudeDegrees!)
            
            func roundToPlaces(value:Double, places:Int) -> Double {
                let divisor = pow(10.0, Double(places))
                return round(value * divisor) / divisor
            }
        }
        
        // Init for address data
        
        if var addressValues = json["properties"] as? [String:AnyObject] {
            city = (addressValues["city"] as? String)
        }
        
        // Init for users data
        
        if let usersvisited = json["usersvisited"] as? [NSDictionary] {
            
            var cumul:Int = 0
            var count:Int = 0
            var sexArray : [String] = []
            
            for uservisited in usersvisited {
                let age:String = uservisited.objectForKey("age") as! String
                let sex:String = uservisited.objectForKey("sex") as! String
                let ageInt = Int(age)
                
                sexArray.append(sex)
                
                count = usersvisited.count
                cumul += ageInt!
                
            }
            
            let sexCount = sexArray.count
            let sexFemaleCount = sexArray.filter {
                $0 == "F"
                }.count
            
            pourcentFemale = (Float(sexFemaleCount) / Float(sexCount))*100
            averageAge = cumul / count
            
        }
    }
*/
    
}

