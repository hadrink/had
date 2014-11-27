//
//  Menu.swift
//  had
//
//  Created by Chris Degas on 20/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit

@objc
class MenuItem {
    
    let title: String
    let image: UIImage
    let status: String
    
    init(title: String, image: UIImage,status: String) {
        self.title = title
        self.image = image
        self.status = status
    }
    
    class func allMenuItems() -> Array<MenuItem> {
        return [ MenuItem(title: "Sleeping Cat",image: UIImage(named: "bottle-active.png")!,status: "active"),
            MenuItem(title: "Pussy Cat",image: UIImage(named:"flux.png")!,status: "inactive"),
            MenuItem(title: "Korat Domestic Cat",image: UIImage(named:"setting.png")!,status: "inactive"),
            MenuItem(title: "Tabby Cat", image: UIImage(named:"turn-off.png")!,status: "inactive")
             ]
    }
}
