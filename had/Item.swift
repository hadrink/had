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
    var fbFriendsImgArray = []
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var percent: UILabel!
    
    @IBOutlet weak var FbCollectionView: UICollectionView!
    var placeId: String!
    var typeofPlace : String?
    var folderCount:Int?
    
    @IBOutlet var routeButton: UIButton!
    
    func configureForPlaceItem(place: PlaceItem) {
        routeButton.layer.zPosition = 100
        routeButton.layer.setNeedsDisplay()
    }
    
    func setCollectionViewDataSourceDelegate
        <D: protocol<UICollectionViewDataSource, UICollectionViewDelegate>>
        (dataSourceDelegate: D, forRow row: Int) {
            
            FbCollectionView.delegate = dataSourceDelegate
            FbCollectionView.dataSource = dataSourceDelegate
            FbCollectionView.tag = row
            FbCollectionView.reloadData()
    }
    
    
    
    
    @IBAction func heartAction(sender: UIButton) {
        
        let moContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
        
        //-- Test if place is in Core Data
        if IsPlaceInCoreData(placeId) {
            
            var places = [Place]()
            let request = NSFetchRequest(entityName: "Place")
            request.includesSubentities = false
            request.returnsObjectsAsFaults = false
            request.includesPropertyValues = false

            
            //-- Declare predicate and get specific value
            
            //TODO
            let predicate = NSPredicate(format: "place_id == '\(placeId)'")
            request.predicate = predicate
            
            do {
                //-- Execute fetch request after set request.predicate
                places = try moContext?.executeFetchRequest(request) as! [Place]
                /*print("nb item dans coredata")
                print(places.count)*/
                //-- Loop on items for delete all items found out
                let item = places.first! as NSManagedObject
                moContext?.deleteObject(item)
                
                try moContext?.save()
            
                //-- Change heart image
                heartButton.setImage(UIImage(named: "heart"), forState: .Normal)
            
            //-- Test if fetch failed
            } catch let error as NSError {
                print("Fetch failed: \(error.localizedDescription)")
            }
            //var cell :UITableViewCell =  sender.superview as! UITableViewCell
            //var index :NSIndexPath =
        }
        
        //-- If is'nt
        else {
            
            let entityName : String = "Place"
            let storeDesctiption = NSEntityDescription.entityForName(entityName, inManagedObjectContext: moContext!)
            let place = Place(entity: storeDesctiption!, insertIntoManagedObjectContext : moContext!)
            //-- Change heart image
            heartButton.setImage(UIImage(named: "heart-hover"), forState: .Normal)
            
            //-- Set values for place_id and set at true is_checked
            /*print("<")
            print("placeid in item")
            print(placeId)*/
            place.setValue(placeId, forKey: "place_id")
            place.setValue(true, forKey: "is_checked")
            place.setValue(typeofPlace, forKey: "place_type")
            place.setValue(placeName.text, forKey: "place_name")
            
            /*print("placeid in item")
            print(placeName.text)
            print(">")*/
            
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


