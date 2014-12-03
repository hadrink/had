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
    
    let placeName: NSString
    let city: NSString
    let distance: NSString
    let averageAge: NSString
    let pourcentage: NSString
    let stats: UIImage

    
    init(placeName: String, city: String, distance: String,stats: UIImage, averageAge: String, pourcentage: String) {
        self.placeName = placeName
        self.city = city
        self.distance = distance
        self.averageAge = averageAge
        self.pourcentage = pourcentage
        self.stats = stats
    }

    class func allPlaceItems() -> Array<PlaceItem> {
        return [ PlaceItem(placeName: "Bougnat",city:"Troyes",distance: "2km",stats: UIImage(named: "stats-icon.png")!,averageAge:"23",pourcentage:"75%"),
            PlaceItem(placeName: "Café",city: "Barberey",distance: "1.5",stats: UIImage(named: "stats-icon.png")!,averageAge:"23",pourcentage:"75%"),
            PlaceItem(placeName: "Bar name",city: "La Chapelle",distance: "1km",stats: UIImage(named: "stats-icon.png")!,averageAge:"23",pourcentage:"75%"),
            PlaceItem(placeName: "Bar name", city: "Sainte Savine",distance: "0;5km",stats: UIImage(named: "stats-icon.png")!,averageAge:"23",pourcentage:"75%")
        ]
    }
}

