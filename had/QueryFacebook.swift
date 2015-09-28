//
//  UserDataFb.swift
//  had
//
//  Created by Kévin Rignault on 22/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserDataFb {
    
    var profilePicture:UIImage?
    var backgroundPicture:UIImage?
    
    var pictureCache = [String : UIImage]()
    let userSetting = SettingsViewController().userDefaults
    let cache:NSCache = NSCache()


    func getPicture() {
        
        print("Func get profil picture")
        
        let pictureRequest = FBSDKGraphRequest(graphPath: "/v2.2/me/picture?type=large&redirect=false", parameters: nil)
        
        print("picture request")
        
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                print("\(result)")
                let data: AnyObject  = result.objectForKey("data")!
                let url :NSString = data.valueForKey("url") as! NSString
                let imageURL = NSURL(string: url as String)
                let nsdata = NSData(contentsOfURL: imageURL!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                

                    self.profilePicture = UIImage(data: nsdata!)
                    self.backgroundPicture = UIImage(data: nsdata!)
                    self.pictureCache["profile_picture"] = UIImage(data: nsdata!)
                    print("Profile picture userData")
                    print(self.pictureCache["profile_picture"]?.description)
                
                    self.cache.setObject(UIImage(data: nsdata!)!, forKey: "profile_picture")
                    print(self.cache.objectForKey("profile_picture")?.description)
                
                
                    let moContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
                
                    do {
                
                    let entityName : String = "Store"
                    let storeDesctiption = NSEntityDescription.entityForName(entityName, inManagedObjectContext: moContext!)
                    print(" Yoyo\(storeDesctiption)")
                    let store = Store(entity: storeDesctiption!, insertIntoManagedObjectContext : moContext!)
                
                    let img = UIImage(data: nsdata!)
                    let imgData = UIImageJPEGRepresentation(img!, 1)
                    store.setValue(imgData, forKey: "sImage")
                
                
                    try moContext?.save()
                        
                    //print("Test sImage\(store.sImage?.description)")
                    print("test sImage")
                    print(store.valueForKey("sImage"))
                
                    }
                
                    catch let err as NSError {
                        
                        print(err)
                
                    }
                
                
                //settingViewController.profilePicture.image = UIImage(data: nsdata!)
                //settingViewController.profilePicture.layer.cornerRadius = settingViewController.profilePicture.frame.size.width / 2
                //settingViewController.profilePicture.clipsToBounds = true;
                
                //settingViewController.backgroundPicture.image = UIImage(data: nsdata!)
                
                //self.profilePicture.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: url as String)!)!)
                print(url)
            } else {
                print("\(error)")
            }
            
        })
        self.test()
    }
    
    
    func test() {
        print("testpicture")
        print(pictureCache["profile_picture"]?.description)
        print(cache.objectForKey("profile_picture")?.description)
        print(cache.description)
    }
        
    
    var friendsDictionary:Dictionary<String, String> = ["":""]
    
    func getFriends() {
        
        let getFriends : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
       
        getFriends.startWithCompletionHandler({ (connection, result, error) -> Void in
           
             // 1
            
            if ((error) != nil) {
                print("Error: \(error)")
            }
            else {
                
                print(result)
                
                var allFriends = [String]()
                let friends = result["data"] as! NSArray
                
                print("friends\(friends)")
                for friend in friends {
                    let thisFriend = friend["id"] as! String
                    allFriends.append(thisFriend)
                    print("Thisfriends\(thisFriend)")

                }
                
                let allFriendsFb = allFriends.joinWithSeparator(",")
                print(allFriendsFb)
                
                
                
                self.friendsDictionary = ["friends":allFriendsFb /*"Birthday":userBirthday*/]
                
                let userSetting = SettingsViewController().userDefaults
                
                userSetting.setObject(allFriends, forKey: "friends")
                
                
            }
            
            
        })
                
    }
    
    func SendUserData() -> Bool
    {
        let methodePost = QueryServices()
        var response:Bool = false
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/v2.2/me", parameters: nil)
        let getFriends : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                print("Error: \(error)")
            }
            else {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                
                print("result FB \(result)")

                let userEmailFb:String = result.valueForKey("email") as! String
                let userFirstnameFb:String = result.valueForKey("first_name") as! String
                let userLastnameFb = result.valueForKey("last_name") as! String
                let userGenderFb = result.valueForKey("gender") as! String
                let userLinkFb = result.valueForKey("link") as! String
                
                //-- Set userData
                print("fetched user: \(result)")
                userDefaults.setValue(userEmailFb as String, forKey: "email")
                userDefaults.setValue(userFirstnameFb as String, forKey: "first_name")
                userDefaults.setValue(userLastnameFb as String, forKey: "last_name")
                userDefaults.setValue(userGenderFb as String, forKey: "gender")
                userDefaults.setValue(userLinkFb as String, forKey: "link")
                //userData.setValue(result.valueForKey("birthday") as? String, forKey: "birthday")
                
                
                //-- user Object
                
                getFriends.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    if ((error) != nil) {
                        print("Error: \(error)")
                    }
                    else {
                        print("Friends\(result)")
                        
                        var allFriends = [String]()
                        let friends = result["data"] as! NSArray
                        for friend in friends {
                            let thisFriend = friend["id"] as! String
                            allFriends.append(thisFriend)
                        }
                        
                        let allFriendsFb = allFriends.joinWithSeparator(",")
                        print(allFriendsFb)

                        let userArray:Dictionary = ["gender":userGenderFb, "email":userEmailFb, "lastname":userLastnameFb, "firstname":userFirstnameFb, "link":userLinkFb, "friends":allFriendsFb /*"Birthday":userBirthday*/]

                        
                        
                        //-- Post method
                        methodePost.post("POST", params: userArray, url: "http://151.80.128.136:3000/user/create/") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                            var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                    
                            print("Response 1 \(response)")

                            
                            if(succeeded) {
                                response = true
                            }
                            else {
                                response = false
                            }
                            
                            print("Response 2 \(response)")
                            
                        }
                    }
                })
            }
        })
        
        return response
        
    }
    
}