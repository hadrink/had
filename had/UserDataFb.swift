//
//  UserDataFb.swift
//  had
//
//  Created by Kévin Rignault on 22/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation

class UserDataFb {
    
    func SendUserData() -> Bool
    {
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
                let userDefaults = NSUserDefaults.standardUserDefaults()

                var userEmailFb:String = result.valueForKey("email") as! String
                var userFirstnameFb:String = result.valueForKey("first_name") as! String
                var userLastnameFb = result.valueForKey("last_name") as! String
                var userGenderFb = result.valueForKey("gender") as! String
                var userLinkFb = result.valueForKey("link") as! String
                
                //-- Set userData
                println("fetched user: \(result)")
                userDefaults.setValue(userEmailFb as String, forKey: "email")
                userDefaults.setValue(userFirstnameFb as String, forKey: "first_name")
                userDefaults.setValue(userLastnameFb as String, forKey: "last_name")
                userDefaults.setValue(userGenderFb as String, forKey: "gender")
                userDefaults.setValue(userLinkFb as String, forKey: "link")
                //userData.setValue(result.valueForKey("birthday") as? String, forKey: "birthday")
                
                
                //-- user Object
                var userArray:Dictionary<String,String> = ["gender":userGenderFb, "email":userEmailFb, "lastname":userLastnameFb, "firstname":userFirstnameFb, "link":userLinkFb /*"Birthday":userBirthday*/]
                
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