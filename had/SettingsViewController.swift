//
//  SettingsViewController.swift
//  had
//
//  Created by chrisdegas on 08/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation
import UIKit

class CellSetting:UITableViewCell{
    
    @IBOutlet weak var titleSetting: UILabel!
    
}


class SettingsViewController: UITableViewController{
    
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
    @IBOutlet var backgroundPicture: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserData()
        
        
        /*self.navigationController?.navigationBar.barTintColor = UIColorFromRGB(0x5a74ae)
        self.navigationController?.navigationBar.translucent = false
        self.navBar.title = "Youhou"*/

    }
    
    /*override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.styleNavBar()
    }
    
    func styleNavBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        var newNavBar:UINavigationBar = UINavigationBar(frame: CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0))
        newNavBar.tintColor = UIColor.whiteColor()
        
        var newItem:UINavigationItem = UINavigationItem()
        
        newItem.title = "Youhou"

        newNavBar.setItems([newItem], animated: true)
        
        self.view.addSubview(newNavBar)
        
    }*/
    
    

    
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
               /* self.Age.text = result.valueForKey("birthday") as? String
                self.Mail.text = result.valueForKey("email") as? String
                self.Gender.text = result.valueForKey("gender") as? String
                self.Loc.text = result.valueForKey("locale") as? String
                //Link.text = userData.valueForKey("link") as? String
                self.Languages.text = result.valueForKey("languages") as? String
                self.SeekingAge.text = result.valueForKey("relationship_status") as? String*/
                
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
                
                self.backgroundPicture.image = UIImage(data: nsdata!)
                
                func blurImage() {
                    var lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                    
                    var blurView = UIVisualEffectView(effect: lightBlur)
                    blurView.frame = self.backgroundPicture.bounds
                    self.backgroundPicture.addSubview(blurView)
                }
                
                blurImage()
                
                
               
                
                //self.profilePicture.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: url as String)!)!)
                println(url)
            } else {
                println("\(error)")
            }
        })
    }
}