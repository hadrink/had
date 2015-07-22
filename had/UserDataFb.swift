//
//  UserDataFb.swift
//  had
//
//  Created by Kévin Rignault on 22/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation

class UserDataFb {
    
    class func UserData() -> Bool
    {
        let userData = NSUserDefaults.standardUserDefaults()
        var methodePost = QueryServices()
        var response:Bool = true
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                println("Error: \(error)")
            }
            else
            {
                //-- Set userData
                println("fetched user: \(result)")
                userData.setValue(result.valueForKey("email") as? String, forKey: "email")
                userData.setValue(result.valueForKey("first_name") as? String, forKey: "first_name")
                userData.setValue(result.valueForKey("last_name") as? String, forKey: "last_name")
                userData.setValue(result.valueForKey("gender") as? String, forKey: "gender")
                userData.setValue(result.valueForKey("link") as? String, forKey: "link")
                //userData.setValue(result.valueForKey("birthday") as? String, forKey: "birthday")
                
                //-- Stock userData
                var userEmail: String = userData.stringForKey("email")!
                var userFirstname: String = userData.stringForKey("first_name")!
                var userLastname: String = userData.stringForKey("last_name")!
                var userGender: String = userData.stringForKey("gender")!
                var userLink: String = userData.stringForKey("link")!
                //var userBirthday: String = userData.stringForKey("birthday")!
                
                //-- user Object
                var userArray:Dictionary<String,String> = ["Gender":userGender, "E-mail":userEmail, "Lastname":userLastname, "Firstname":userFirstname, "Link":userLink /*"Birthday":userBirthday*/]
                
                //-- Post method
                methodePost.post(userArray, url: "http://151.80.128.136:3000/user/create/") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                    var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                    
                    if(succeeded) {
                        response = true
                    }
                        
                    else {
                        response = false
                    }
                }
            }
        })
        
        return response
    }
    
}