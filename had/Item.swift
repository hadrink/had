//
//  Item.swift
//  had
//
//  Created by Chris Degas on 27/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var menuCellImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    
    func configureForMenuItem(item: MenuItem) {
        menuCellImageView.image = item.image
        imageNameLabel.text = item.title
    }
}

class PlaceCell: UITableViewCell {
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var stats: UIImageView!
    @IBOutlet weak var details: UILabel!
    @IBOutlet var subView: UIView!
    @IBOutlet var statIcon: UIImageView!
    
    
    func configureForPlaceItem(place: PlaceItem) {
        placeName.text = place.placeName.uppercaseString
        city.text = place.city
        distance.text = place.distance
        stats.image = place.stats
        details.text = place.pourcentage
        subView.layer.opacity = 0
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        if (self.frame.height > 80){
            subView.layer.opacity = 1
        }
        
    
        statIcon.image = UIImage(named: "stats-icon@3x")
        
    }
    
}


