//
//  QueryServices
//  Status
//
//  Created by Rplay on 21/08/2014.
//  Copyright (c) 2014 Christopher Degas. All rights reserved.
//

import UIKit

class QueryServices{
    
    var userData :NSDictionary = NSDictionary()
    
    func post(HTTPMethod: String, params : Dictionary<String, String>, url : String, postCompleted : (succeeded: Bool, msg: String, obj : NSDictionary) -> ()) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = HTTPMethod
        
        let err: NSError?
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                //println("Response: \(response)")
                var strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //println("Body: \(strData)")
                var err: NSError?
                
                do {
                
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                    
                    var msg = "No message"
                    
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    if(err != nil) {
                        print(err!.localizedDescription)
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse JSON: '\(jsonStr)'")
                        if(json != nil){
                            postCompleted(succeeded: false, msg: "Error", obj : json!)
                        }
                    }
                    else {
                        // The JSONObjectWithData constructor didn't return an error. But, we should still
                        // check and make sure that json has a value using optional binding.
                        if let parseJSON = json {
                            // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                            if let success = parseJSON["success"] as? Bool {
                                print("Succes: \(success)")
                                postCompleted(succeeded: success, msg: "Logged in.", obj : json!)
                            }
                                
                            else {
                                postCompleted(succeeded: true, msg: "ParsedJson", obj: json!)
                            }
                        }
                        else {
                            // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                            let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            print("Error could not parse JSON: \(jsonStr)")
                            postCompleted(succeeded: false, msg: "Error", obj : json!)
                        }
                    }
                    
                }
                
                catch {
                    print(err)
                }
                
                
            })
            
            task.resume()
            
        }
        
        catch {

        }
        
        
    }

        
    
    /*func get(url : String /*, postCompleted : (succeeded: Bool, msg: String, obj : NSDictionary) -> ()*/) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "GET"
        
        var err: NSError?
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
        })
        
        task.resume()
    }*/
    
    
    func delete(params : Dictionary<String, String>,url : String) {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "DELETE"
        
        let err: NSError?
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")
                let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Body: \(strData)")
                let err: NSError?
                
                do {
            
                    var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
                    
                }
                
                catch {

                }
                
            })
            
            task.resume()

        }
        
        catch {

        }
        
        
    }
    
    /*func put(params : Dictionary<String, String>, url : String) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "PUT"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: .PrettyPrinted)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }*/

    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                //self.SaveUserDataToPList(result)
                //self.userData = result
                //println("fetched user: \(self.userData)")
                // result
                /*println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
                let gender : NSString = result.valueForKey("gender") as! NSString
                println("User gender is: \(gender)")
                let local : NSString = result.valueForKey("locale") as! NSString
                println("User local is: \(local)")
                let link : NSString = result.valueForKey("link") as! NSString
                println("User link is: \(link)")*/
                
            }
        })
    }
    /*var userName:AnyObject = 101
    func loadUserDataFromPList() {
        // getting path to GameData.plist
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths[0] as! String
        let path = documentsDirectory.stringByAppendingPathComponent("user.plist")
        let fileManager = NSFileManager.defaultManager()
        //check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("user", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                println("Bundle GameData.plist file is --> \(resultDictionary?.description)")
                fileManager.copyItemAtPath(bundlePath, toPath: path, error: nil)
                println("copy")
            } else {
                println("GameData.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            println("GameData.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        println("Loaded GameData.plist file is --> \(resultDictionary?.description)")
        var myDict = NSDictionary(contentsOfFile: path)
        if let dict = myDict {
            //loading values
            userName = dict.objectForKey("Firstname")!
//            bedroomWallID = dict.objectForKey(BedroomWallKey)!
            //...
        } else {
            println("WARNING: Couldn't create dictionary from GameData.plist! Default values will be used!")
        }
    }*/
    
    /*func SaveUserDataToPList(userData: AnyObject)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDirectory = paths.objectAtIndex(0) as! NSString
        let path = documentsDirectory.stringByAppendingPathComponent("user.plist")
        var dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        //saving values
        let userName :NSString = userData.valueForKey("name") as! NSString
        dict.setObject(userName, forKey: "Firstname")
//        dict.setObject(bedroomWallID, forKey: BedroomWallKey)
        //...
        //writing to GameData.plist
        dict.writeToFile(path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: path)
        print("Saved GameData.plist file is --> \(resultDictionary?.description)")
    }*/
}
