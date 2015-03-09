//
//  UserManager.swift
//  Status
//
//  Created by Chris Degas on 17/07/2014.
//  Copyright (c) 2014 Christopher Degas. All rights reserved.
//

import UIKit
import CoreData
/*
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
*/
class User{
    var name: String
    var lastname: String
    var mail: String
    var gender:Int=0
    var birthDate: NSDate
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

    
    func getAge(/*birth: NSDate*/) -> Float{
        var age = -birthDate.timeIntervalSinceNow
        age /= 31536000
        return ceil(Float(age))
    }
    
    func getUserCoreData(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        var fetchedResults = executeRequest(managedContext)
        var result: NSManagedObject
        
        println("result")
        for result in fetchedResults
        {
            println(result.valueForKey("name"))
            println(result.valueForKey("lastname"))
            println(result.valueForKey("mail"))
            println(result.valueForKey("gender"))
            println(result.valueForKey("birthdate"))
            self.name=result.valueForKey("name") as String
            self.lastname=result.valueForKey("lastname") as String
            self.mail = result.valueForKey("mail") as String
            self.gender = result.valueForKey("gender") as Int
            self.birthDate = result.valueForKey("birthdate") as NSDate
        }
        if fetchedResults.count == 0 {
            println("Could not fetch ")
        }
        
    }
    func saveUserCoreData(name: String,lastname:String,mail: String,gender:Int,birthDate: NSDate) {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        var fetchedResults = executeRequest(managedContext)
        deleteUserCoreData(managedContext,fetchedResults: fetchedResults)
        let entity =  NSEntityDescription.entityForName("User",inManagedObjectContext:managedContext)
        
        let profil = NSManagedObject(entity: entity!,insertIntoManagedObjectContext:managedContext)
        profil.setValue(name, forKey: "name")
        profil.setValue(lastname, forKey: "lastname")
        profil.setValue(mail, forKey: "mail")
        profil.setValue(gender, forKey: "gender")
        profil.setValue(birthDate, forKey: "birthdate")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        self.name=name
        self.lastname=lastname
        self.mail = mail
        self.gender = gender
        self.birthDate = birthDate
        
        println(name)
        println(lastname)
        println(mail)
        println(gender)
       // println(birthdate.date.description)
//        user.userProfil.append(profil)
    }
    
    private func executeRequest(managedContext:NSManagedObjectContext)-> NSArray
    {
        let fetchRequest = NSFetchRequest(entityName:"User")
        //let predicate = NSPredicate(format: "mail != %@", "")
        //fetchRequest.predicate = predicate
        var error: NSError?
        let fetchedResults: NSArray = managedContext.executeFetchRequest(fetchRequest,error: &error)!
        return fetchedResults
    }
    
    private func deleteUserCoreData(managedContext:NSManagedObjectContext,fetchedResults:NSArray)
    {
        var saveError: NSError?
        //Delete all users in core data
         for result in fetchedResults
        {
            print(" avant : ")
            println(result.valueForKey("name"))
            managedContext.deleteObject(result as NSManagedObject)
            managedContext.save(&saveError)
            print(" apres : ")
            println(result.valueForKey("name"))
        }
    }
}