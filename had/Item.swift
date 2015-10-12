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

    @IBOutlet weak var fbFriendsImg: UIImageView!
    
    @IBOutlet var routeButton: UIButton!
    
    func configureForPlaceItem(place: PlaceItem) {
        routeButton.layer.zPosition = 100
        routeButton.layer.setNeedsDisplay()
        
    }
    
}


