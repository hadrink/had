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
    var showDetails : Bool = false
    
    // Init variables
    override init() {
        //default
    }
     init (json : NSDictionary, userLocation : NSDictionary) {
        
        // Init for place name and counter
        //print(json)
        
        placeId = json["_id"] as? String
        
        if var placeProperties = json["properties"] as? [String:AnyObject] {
            placeName = placeProperties["name"] as? String
            typeofPlace = placeProperties["amenity"] as? String
        }
        
        // Get friends visited place
        
        friends = json["friends"] as? Array<String>
        print(friends)
        
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
            showDetails = true
            print("visitorsss")
            print(usersvisited)
            //Uncomment following to ensure the robustness of friends if there is a bug, just in case
            //var ids :[String] = []
            for uservisited in usersvisited {
                /*let id:String = uservisited["id_facebook"] as! String
                if(ids.indexOf(id) == nil)
                {
                    ids.append(id)*/
                    var ageInt = 0
                    if let age:String = uservisited["age"] as? String
                    {
                        print(age)
                        ageInt = Int(age)!
                    }
                    if let sex:String = uservisited["sex"] as? String
                    {
                        print(sex)
                        sexArray.append(sex)
                    }
                    
                    count = usersvisited.count
                  //  count++
                    cumul += ageInt
                //}
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
}

