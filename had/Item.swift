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
        placeName.text = place.placeName as String
        city.text = place.city as String
        distance.text = place.distance as String
        details.text = place.pourcentage as String
        nbUser.text = place.nbUser as String
        averageAge.text = place.averageAge as String
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        
    }
    
}


