//
//  Menu.swift
//  had
//
//  Created by Chris Degas on 20/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit

@objc
class Information {
    
    let title: String
    let creator: String
    
    init(title: String, creator: String) {
        self.title = title
        self.creator = creator
    }
    
    class func allInformations() -> Array<Information> {
        return [ Information(title: "Sleeping Cat", creator: "papaija2008"),
            Information(title: "Pussy Cat", creator: "Carlos Porto"),
            Information(title: "Korat Domestic Cat", creator: "sippakorn"),
            Information(title: "Tabby Cat", creator: "dan"),
            Information(title: "Yawning Cat", creator: "dan"),
            Information(title: "Tabby Cat", creator: "dan"),
            Information(title: "Cat On The Rocks", creator: "Willem Siers"),
            Information(title: "Brown Cat Standing", creator: "aopsan"),
            Information(title: "Burmese Cat", creator: "Rosemary Ratcliff"),
            Information(title: "Cat", creator: "dan"),
            Information(title: "Cat", creator: "graur codrin") ]
    }
}
