//
//  StaticData.swift
//  had
//
//  Created by chrisdegas on 17/02/2015.
//  Copyright (c) 2015 had. All rights reserved.
//
import CoreData
import UIKit
import Foundation

struct Urls {
    
    static let urlListPlace = "https://hadrink.herokuapp.com/list/had/"
    static let createUser = "https://hadrink.herokuapp.com/users/create/"
    
}
struct user {
    static var userProfil = [NSManagedObject]()
}

struct Colors {
    let pink = Design().UIColorFromRGB(0xFA6D84)
    let blue = Design().UIColorFromRGB(0x5A74AE)
    let lightBlue = Design().UIColorFromRGB(0x5B90CE)
    let grey = Design().UIColorFromRGB(0xFCFCFB)
    let darkGrey = Design().UIColorFromRGB(0xE3E2E2)
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
    
    func generateRandomData() -> [[UIColor]] {
        let numberOfRows = 20
        let numberOfItemsPerRow = 15
        return (0..<numberOfRows).map { _ in
            return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
        }
    }
    
}

class SettingDefault {
        
    var distanceMax:Float = 50;
    var ageMin:Double = 18
    var ageMax:Double = 30
    var displayBar:Bool = true
    var displayNightclub:Bool = true
    var statsSince = 31
    
}

struct alertMessage {
    static let titleAlertLocationManagerOff = "Service de Localisation Désactivé"
    static let messageAlertLocationManagerOff = "Merci d'activer le service de localisation dans les Réglages !"
    static let alertActionOK = "OK"
    static let alertActionSettings = "Réglages"
}

extension String {
    
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGFloat {
        
        var textSize:CGSize!
        
        if CGSizeEqualToSize(size, CGSizeZero) {
            
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            
            textSize = self.sizeWithAttributes(attributes as! [String : AnyObject] as [String : AnyObject])
            
        } else {
            
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            
            let attributes = NSDictionary(object: font, forKey: NSFontAttributeName)
            
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes as! [String : AnyObject] as [String : AnyObject], context: nil)
            
            textSize = stringRect.size
            
        }
        
        return textSize.width
        
    }
    
}
