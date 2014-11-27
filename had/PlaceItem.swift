//
//  PlaceItem.swift
//  had
//
//  Created by Chris Degas on 27/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit

@objc
class PlaceItem {
    
    let placeName: String
    let city: String
    let distance: String

    
    init(placeName: String, city: String, distance: String) {
        self.placeName = placeName
        self.city = city
        self.distance = distance
    }

}

