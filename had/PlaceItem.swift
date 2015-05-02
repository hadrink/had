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
    let nbUser: NSString
    let stats: UIImage

    
    init(placeName: String, city: String, distance: String,stats: UIImage, averageAge: String, pourcentage: String, nbUser: String) {
        self.placeName = placeName
        self.city = city
        self.distance = distance
        self.averageAge = averageAge
        self.pourcentage = pourcentage
        self.stats = stats
        self.nbUser = nbUser
    }

    class func allPlaceItems() -> Array<PlaceItem> {
        return [ PlaceItem(placeName: "Bougnat des Pouilles",city:"Troyes",distance: "2km",stats: UIImage(named: "stats-icon.png")!,averageAge:"23 - 24",pourcentage:"75%", nbUser:"150 Hadder ces 30 derniers jours"),
            PlaceItem(placeName: "Café",city: "Barberey",distance: "1.5",stats: UIImage(named: "stats-icon.png")!,averageAge:"23 - 24",pourcentage:"75%", nbUser:"150 Hadder ces 30 derniers jours"),
            PlaceItem(placeName: "Bar name",city: "La Chapelle",distance: "1km",stats: UIImage(named: "stats-icon.png")!,averageAge:"22 - 23",pourcentage:"75%", nbUser:"150 Hadder ces 30 derniers jours"),
            PlaceItem(placeName: "Bar name", city: "Sainte Savine",distance: "0;5km",stats: UIImage(named: "stats-icon.png")!,averageAge:"12 - 13",pourcentage:"75%", nbUser:"150 Hadder ces 30 derniers jours")
        ]
    }
}

