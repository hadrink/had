//
//  SettingsViewController.swift
//  had
//
//  Created by chrisdegas on 08/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation


class SettingsViewController: UIViewController{
    
    let QServices = QueryServices()
    
    @IBOutlet var Name: UILabel!
    @IBOutlet var Mail: UILabel!
    @IBOutlet var Age: UILabel!
    @IBOutlet var Gender: UILabel!
    @IBOutlet var Loc: UILabel!
    @IBOutlet var Languages: UILabel!
    @IBOutlet var Places: UILabel!
    @IBOutlet var Musics: UILabel!
    @IBOutlet var SeekingAge: UILabel!
    
    @IBOutlet var profilePicture: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserData()
    }
    
    func UserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                println(result.valueForKey("age_range") as? String)
                self.Name.text = result.valueForKey("name") as? String
                self.Age.text = result.valueForKey("birthday") as? String
                self.Mail.text = result.valueForKey("email") as? String
                self.Gender.text = result.valueForKey("gender") as? String
                self.Loc.text = result.valueForKey("locale") as? String
                //Link.text = userData.valueForKey("link") as? String
                self.Languages.text = result.valueForKey("languages") as? String
                self.SeekingAge.text = result.valueForKey("relationship_status") as? String
                
            }
        })
        
        let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                println("\(result)")
                var data: AnyObject  = result.objectForKey("data")!
                var url :NSString = data.valueForKey("url") as! NSString
                let imageURL = NSURL(string: url as String)
                let nsdata = NSData(contentsOfURL: imageURL!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                self.profilePicture.image = UIImage(data: nsdata!)
                self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
                self.profilePicture.clipsToBounds = true;
                //self.profilePicture.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: url as String)!)!)
                println(url)
            } else {
                println("\(error)")
            }
        })
    }
}