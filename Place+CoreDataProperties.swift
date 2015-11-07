//
//  Place+CoreDataProperties.swift
//  had
//
//  Created by Rplay on 05/11/15.
//  Copyright © 2015 had. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Place {

    @NSManaged var place_id: String?
    @NSManaged var is_checked: NSNumber?

}
