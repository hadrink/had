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

    class func allPlaceItems() -> Array<PlaceItem> {
        return [ PlaceItem(placeName: "Bougnat",city:"Troyes",distance: "2km"),
            PlaceItem(placeName: "Café",city: "Barberey",distance: "1.5"),
            PlaceItem(placeName: "Bar name",city: "La Chapelle",distance: "1km"),
            PlaceItem(placeName: "Bar name", city: "Sainte Savine",distance: "0;5km")
        ]
    }
}

