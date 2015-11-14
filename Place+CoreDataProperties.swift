//
//  Place+CoreDataProperties.swift
//  had
//
//  Created by chrisdegas on 13/11/2015.
//  Copyright © 2015 had. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Place {

    @NSManaged var is_checked: NSNumber?
    @NSManaged var place_id: String?
    @NSManaged var place_name: String?
    @NSManaged var place_city: String?
    @NSManaged var place_counter: NSNumber?
    @NSManaged var place_average_age: NSNumber?
    @NSManaged var place_pourcent_sex: NSNumber?
    @NSManaged var place_distance: NSNumber?
    @NSManaged var place_latitude: NSNumber?
    @NSManaged var place_longitude: NSNumber?
    @NSManaged var place_type: String?

}
