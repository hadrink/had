//
//  StaticData.swift
//  had
//
//  Created by chrisdegas on 17/02/2015.
//  Copyright (c) 2015 had. All rights reserved.
//
import CoreData

struct Urls {
    
    static let urlListPlace = "http://151.80.128.136:3000/list/had/"
    
}
struct user {
    static var userProfil = [NSManagedObject]()
}

struct Design {
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}