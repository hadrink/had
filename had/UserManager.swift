//
//  UserManager.swift
//  Status
//
//  Created by Chris Degas on 17/07/2014.
//  Copyright (c) 2014 Christopher Degas. All rights reserved.
//

import UIKit

var UserMgr = UserManager()

class UserManager: NSObject {
    var users = [User]()
    
    func addUser(user: User){
        users.append(user)
    }
    
    func getAverageAge() -> Float{
        var average : Float = 0.0
        for user in users{
            average += user.getAge(/*user.birthDate*/)
        }
        average /= Float(users.count)
        return average
    }
    
    func getPercentageGender() -> Float{
        var percentage : Float = 0.0
        for user in users{
            if user.gender == "Homme"{
                percentage++
            }
        }
        percentage /= Float(users.count*100)
        return percentage
    }
}

struct Location {
    var lat:Double = 0.0
    var lng:Double = 0.0
}

class User{
    var name: String?
    var lastname: String?
    var mail: String = ""
    var password: String = "password"
    var gender = "Homme"
    var birthDate: NSDate
    //var position = Location();
    
    init(mail:String, pwd:String,gend:String, birth:NSDate) {
       
        self.mail = mail
        self.password = pwd
        self.gender = gend
        self.birthDate = birth
    }

    
    func getAge(/*birth: NSDate*/) -> Float{
        var age = -birthDate.timeIntervalSinceNow
        age /= 31536000
        return ceil(Float(age))
    }
    /*func setLocation(latitude: Double,longitude :Double){
        self.position.lat = latitude
        self.position.lng = longitude
    }*/
}