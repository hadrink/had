//
//  Item.swift
//  had
//
//  Created by Chris Degas on 27/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit
import CoreData

class MenuCell: UITableViewCell {
    
    @IBOutlet weak var menuCellImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    
}

class PlaceCell: UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var stats: UIImageView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var nbUser: UILabel!
    @IBOutlet weak var averageAge: UILabel!
    @IBOutlet weak var getLocation: UIButton!
    @IBOutlet weak var iconTableview: UIImageView!
    @IBOutlet weak var backgroundNbUser: UIView!
    @IBOutlet weak var backgroundAge: UIView!
    @IBOutlet weak var backgroundSex: UIView!
    @IBOutlet weak var sexIcon: UIImageView!
    @IBOutlet weak var fbFriendsImg1: UIImageView!
    @IBOutlet weak var fbFriendsImg2: UIImageView!
    @IBOutlet weak var fbFriendsImg3: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    
    var placeId: String!
    var typeofPlace : String?
    
    @IBOutlet var routeButton: UIButton!
    
    func configureForPlaceItem(place: PlaceItem) {
        routeButton.layer.zPosition = 100
        routeButton.layer.setNeedsDisplay()
        
    }
    
    
    
    
    
    
    @IBAction func heartAction(sender: UIButton) {
        
        let moContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        var places = [Place]()
        let entityName : String = "Place"
        let storeDesctiption = NSEntityDescription.entityForName(entityName, inManagedObjectContext: moContext!)
        let place = Place(entity: storeDesctiption!, insertIntoManagedObjectContext : moContext!)
        
        //-- Test if place is in Core Data
        if IsPlaceInCoreData(placeId) {
            
            let request = NSFetchRequest(entityName: "Place")
            request.includesSubentities = false
            request.returnsObjectsAsFaults = false
            request.includesPropertyValues = false

            
            //-- Declare predicate and get specific value
            
            //TODO
            //let predicate = NSPredicate(format: "place_id = %@", placeId)
//            NSPredicate(format: "place_id == '\(placeId)'")
            //request.predicate = predicate
            
            do {
                
                //-- Execute fetch request after set request.predicate
                places = try moContext?.executeFetchRequest(request) as! [Place]
                print("nb item dans coredata")
                print(places.count)
                //-- Loop on items for delete all items found out

                //let item = items.first as! NSManagedObject
                for item in places {
                    print(item.place_name)
                    moContext?.deleteObject(item)
                }
//                items.removeAtIndex(0)
                //-- Save context

                do {
                    try moContext?.save()
                    /*dispatch_async(dispatch_get_main_queue()) {
                        print("dispatch async coredata")
                    }*/
                } catch {
                    let saveError = error as NSError
                    print("save ko")
                    print(saveError)
                }
                let request2 = NSFetchRequest(entityName: "Place")
                    
                places = try moContext?.executeFetchRequest(request2) as! [Place]
                print("nb item dans coredata apres delete")
                print(places.count)
                //-- Change heart image
                heartButton.setImage(UIImage(named: "heart"), forState: .Normal)
            
            //-- Test if fetch failed
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
            
        }
        
        //-- If is'nt
        else {
            
            //-- Change heart image
            heartButton.setImage(UIImage(named: "heart-hover"), forState: .Normal)
            
            //-- Set values for place_id and set at true is_checked
            print("<")
            print("placeid in item")
            print(placeId)
            place.setValue(placeId, forKey: "place_id")
            place.setValue(true, forKey: "is_checked")
            place.setValue(typeofPlace, forKey: "place_type")
            place.setValue(placeName.text, forKey: "place_name")
            
            print("placeid in item")
            print(placeName.text)
            print(">")
            
            place.setValue(city.text, forKey: "place_city")
            place.setValue(Double(distance.text!), forKey: "place_distance")
            place.setValue(Int(nbUser.text!), forKey: "place_counter")
            place.setValue(Float(averageAge.text!) , forKey: "place_average_age")
            //place.setValue(, forKey: "place_latitude")
            //place.setValue(city, forKey: "place_longitude")
            place.setValue(Float(details.text!), forKey: "place_pourcent_sex")
            
            do {
                
                //-- Save context
                try moContext?.save()
                
            }
             
            //-- if error catch it
            catch let err as NSError {
                print(err)
                
            }

        }
        //MainViewController().tableData.reloadData()
    }
}


