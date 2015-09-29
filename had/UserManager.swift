//
//  UserManager.swift
//  Status
//
//  Created by Chris Degas on 17/07/2014.
//  Copyright (c) 2014 Christopher Degas. All rights reserved.
//

import UIKit
import CoreData

class User{
    var name: String?
    var lastname: String?
    var mail: String?
    var gender:Int=0
    var birthDate: NSDate?
    //var position = Location();
    init(){
        self.name = ""
        self.lastname = ""
        self.mail = ""
        self.gender=0
        self.birthDate = NSDate()
    }
    init(name :String,lastname:String,mail:String,gend:Int, birth:NSDate) {
       
        self.lastname = lastname
        self.name = name
        self.mail = mail
        self.gender = gend
        self.birthDate = birth
    }
 }