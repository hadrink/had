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
    
    var placeId: String = ""
    
    @IBOutlet var routeButton: UIButton!
    
    func configureForPlaceItem(place: PlaceItem) {
        routeButton.layer.zPosition = 100
        routeButton.layer.setNeedsDisplay()
        
    }
    
    let moContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var places = [Place]()
    
    let request = NSFetchRequest(entityName: "Place")
    
    
    @IBAction func heartAction(sender: UIButton) {
        let entityName : String = "Place"
        let storeDesctiption = NSEntityDescription.entityForName(entityName, inManagedObjectContext: moContext!)
        let place = Place(entity: storeDesctiption!, insertIntoManagedObjectContext : moContext!)
        
        //-- Test if place is in Core Data
        if MainViewController().IsPlaceInCoreData(placeId) {
            
            request.includesSubentities = false
            request.returnsObjectsAsFaults = false
            
            //-- Declare predicate and get specific value
            let predicate = NSPredicate(format: "place_id == '\(placeId)'")
            request.predicate = predicate
            
            do {
                //-- Execute fetch request after set request.predicate
                let items = try moContext!.executeFetchRequest(request)
                
                //-- Loop on items for delete all items found out
                for item in items {
                    moContext?.deleteObject(item as! NSManagedObject)
                }
                
                //-- Save context
                try moContext?.save()
                
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
            place.setValue(placeId, forKey: "place_id")
            place.setValue(true, forKey: "is_checked")
            
            do {
                
                //-- Save context
                try moContext?.save()
                
            }
             
            //-- if error catch it
            catch let err as NSError {
                print(err)
                
            }

        }
        
    }
}


