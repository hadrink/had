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
    
    //let userDataFb = UserDataFb.sharedInstance

    let QServices = QueryServices()
    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    // Outlets setting

    @IBOutlet weak var ageMin: UILabel!
    @IBOutlet weak var ageMax: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var barSwitch: UISwitch!
    @IBOutlet weak var nightclubSwitch: UISwitch!
    @IBOutlet weak var femaleCheckmarkCell: UITableViewCell!
    @IBOutlet weak var maleCheckmarkCell: UITableViewCell!
    @IBOutlet weak var nomatterCheckmarkCell: UITableViewCell!
    @IBOutlet weak var oneweekCheckmarkCell: UITableViewCell!
    @IBOutlet weak var twoweeksCheckmarkCell: UITableViewCell!
    @IBOutlet weak var monthCheckmarkCell: UITableViewCell!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    @IBOutlet var Name: UILabel!
    @IBOutlet var Mail: UILabel!
    @IBOutlet var Age: UILabel!
    @IBOutlet var Gender: UILabel!
    @IBOutlet var Loc: UILabel!
    @IBOutlet var Languages: UILabel!
    @IBOutlet var Places: UILabel!
    @IBOutlet var Musics: UILabel!
    @IBOutlet var SeekingAge: UILabel!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var backgroundPicture: UIImageView!
    
    @IBOutlet weak var contentViewTest: UIView!
    
    @IBOutlet var contentViewTest2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
       

        
        if (userDefaults.objectForKey("SwitchStateBar") != nil) {
            barSwitch.on = userDefaults.boolForKey("SwitchStateBar")
        }
        
        if (userDefaults.objectForKey("SwitchStateNightclub") != nil) {
            nightclubSwitch.on = userDefaults.boolForKey("SwitchStateNightclub")
        }
        
        
        distanceLabel.text = String(stringInterpolationSegment: Int(userDefaults.floatForKey("DistanceValue"))) + " km"
        
        ageMin.text = String(stringInterpolationSegment: Int(userDefaults.floatForKey("AgeMinValue")))
                
        if ageMax.text == "0"{
            ageMax.text == String(stringInterpolationSegment: Int(rangeSlider.upperValue))
        }
        else {
            ageMax.text = String(stringInterpolationSegment: Int(userDefaults.floatForKey("AgeMaxValue"))) + " ans"
        }
        
        //UserData()
        contentViewTest2.addSubview(rangeSlider)
        contentViewTest2.addSubview(ageLabel)

        nomatterCheckmarkCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        monthCheckmarkCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        print("Bob\(rangeSlider.accessibilityElementCount())")
        
        
        let rangeSliderConstraint = NSLayoutConstraint(item: rangeSlider, attribute:
            .TopMargin, relatedBy: .Equal, toItem: ageLabel,
            attribute: .TopMargin, multiplier: 1.0, constant: 20)
        
        
        print("get image picture")
       
        

        
        print("profile picture setting")
        print(UserDataFb().pictureCache.description)
        self.profilePicture.image = UserDataFb().pictureCache["profile_picture"]
        self.backgroundPicture.image = UserDataFb().pictureCache["profile_picture"]
        
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true;
        
        
        blurImage()

        
    }
    
     override func viewDidLayoutSubviews() {
        let marginTop: CGFloat = 10.0
        let marginBottom: CGFloat = 5
        let width = view.bounds.width - 2.0 * 16
        rangeSlider.frame = CGRect(x: 16, y: 27,
            width: width, height: 30.0)
    }
    
    func blurImage() {
        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        
        let blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = backgroundPicture.bounds
        backgroundPicture.addSubview(blurView)
    }

    
    // Save user config
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func saveSwitchState(sender: AnyObject) {
        
        if barSwitch.on {
            userDefaults.setBool(true, forKey: "SwitchStateBar")
        } else {
            userDefaults.setBool(false, forKey: "SwitchStateBar")
        }
        
        if nightclubSwitch.on {
            userDefaults.setBool(true, forKey: "SwitchStateNightclub")
        } else {
            userDefaults.setBool(false, forKey: "SwitchStateNightclub")
        }
        
        userDefaults.setFloat(distanceSlider.value, forKey: "DistanceValue")
        distanceLabel.text = String(stringInterpolationSegment: Int(distanceSlider.value)) + " km"
        
        
                
    }
    
    let queryServices = QueryServices()
    let userDefault = NSUserDefaults.standardUserDefaults()
    let FBLogOut = FBSDKLoginManager()
    
    @IBAction func deleteUserAccount(sender: AnyObject) {
        
        print("Userdefault\(userDefault.dictionaryRepresentation().keys)")
        
        let email:String = userDefault.stringForKey("email")!
        
        let emailDict:Dictionary<String,String> = ["email": email]
        
        queryServices.post("DELETE", params: emailDict, url: "http://151.80.128.136:3000/user/delete") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
            
            if(succeeded) {
                print("Delete account : DONE")
                self.userDefault.removeObjectForKey("email")
                //println(self.userDefault.stringForKey("email"))
                self.FBLogOut.logOut()
                let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
            else {
                print("Failed to delete your account. Please try again later.")
            }
        }
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
        
        userDefaults.setFloat(Float(rangeSlider.lowerValue), forKey: "AgeMinValue")
        userDefaults.setFloat(Float(rangeSlider.upperValue), forKey: "AgeMaxValue")
        
        ageMin.text = String(stringInterpolationSegment: Int(rangeSlider.lowerValue))
        ageMax.text = String(stringInterpolationSegment: Int(rangeSlider.upperValue)) + " ans"
        
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let section = indexPath.section
        
        if (section == 2 || section == 3) {
        
            let numberOfRows = tableView.numberOfRowsInSection(section)
            for row in 0..<numberOfRows {
                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) {
                    cell.accessoryType = row == indexPath.row ? .Checkmark : .None
                }
            }
        }
    }
    
    /*func UserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                print(result.valueForKey("age_range") as? String)
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
        
        /*let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
        pictureRequest.startWithCompletionHandler({
            (connection, result, error: NSError!) -> Void in
            if error == nil {
                print("\(result)")
                var data: AnyObject  = result.objectForKey("data")!
                var url :NSString = data.valueForKey("url") as! NSString
                let imageURL = NSURL(string: url as String)
                let nsdata = NSData(contentsOfURL: imageURL!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                self.profilePicture.image = UIImage(data: nsdata!)
                self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2
                self.profilePicture.clipsToBounds = true;
                
                self.backgroundPicture.image = UIImage(data: nsdata!)
                
                func blurImage() {
                    let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                    
                    let blurView = UIVisualEffectView(effect: lightBlur)
                    blurView.frame = self.backgroundPicture.bounds
                    self.backgroundPicture.addSubview(blurView)
                }
                
                blurImage()
                
                
               
                
                //self.profilePicture.image = UIImage(data: NSData(contentsOfURL: NSURL(fileURLWithPath: url as String)!)!)
                print(url)
            } else {
                print("\(error)")
            }
        })*/
    }*/
}