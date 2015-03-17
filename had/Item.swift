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
    @IBOutlet weak var nbUser: UILabel!
    @IBOutlet weak var averageAge: UILabel!
    @IBOutlet weak var getLocation: UIButton!
    
    
    func configureForPlaceItem(place: PlaceItem) {
        placeName.text = place.placeName
        city.text = place.city
        distance.text = place.distance
        details.text = place.pourcentage
        nbUser.text = place.nbUser
        averageAge.text = place.averageAge
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        
    }
    
}


