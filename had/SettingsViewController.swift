//
//  SettingsViewController.swift
//  had
//
//  Created by chrisdegas on 08/07/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CellSetting:UITableViewCell{
    
    @IBOutlet weak var titleSetting: UILabel!
    
}



class SettingsViewController: UITableViewController, UIGestureRecognizerDelegate{
    
    //let userDataFb = UserDataFb.sharedInstance

    let QServices = QueryServices()
    let rangeSlider = RangeSlider(frame: CGRectZero)
    let settingDefault = SettingDefault()
    
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Réglages"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Lato-BoldItalic", size: 20)!]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.navigationController?.navigationBar.barTintColor = Design().UIColorFromRGB(0x5b90ce)
        self.navigationController?.navigationBar.translucent = false
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "had-return"), style: .Plain, target: self, action: "goToMainView:")
        navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
        rightBarButtonItem.tintColor = Colors().grey
        
    }
    
    func goToMainView(button: UIBarButtonItem) {
        pageController.goToNextVC()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //-- Set design for profile views
        designProfileViews()
        
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        
        // Get First name and Last name and display it in view
        self.Name.text = (userDefaults.stringForKey("first_name")! + " " + userDefaults.stringForKey("last_name")!)
        
        print("distanceSlider\(distanceSlider.value)")
       
        if userDefaults.floatForKey("DistanceValue").isZero {
            print("Je suis dedans")
            distanceSlider.value = settingDefault.distanceMax
            distanceLabel.text = String(Int(settingDefault.distanceMax)) + " km"
        } else {
            distanceSlider.value = userDefaults.floatForKey("DistanceValue")
            distanceLabel.text = String(stringInterpolationSegment: Int(userDefaults.floatForKey("DistanceValue"))) + " km"
        }

        
        if (userDefaults.objectForKey("SwitchStateBar") != nil) {
            barSwitch.on = userDefaults.boolForKey("SwitchStateBar")
        }
        
        if (userDefaults.objectForKey("SwitchStateNightclub") != nil) {
            nightclubSwitch.on = userDefaults.boolForKey("SwitchStateNightclub")
        }
        
        if userDefaults.floatForKey("AgeMinValue").isZero {
            ageMin.text = String(Int(settingDefault.ageMin))
            rangeSlider.lowerValue = settingDefault.ageMin
        } else {
            ageMin.text = String(Int(userDefaults.doubleForKey("AgeMinValue")))
            rangeSlider.lowerValue = userDefaults.doubleForKey("AgeMinValue")
        }
        
        if userDefaults.floatForKey("AgeMaxValue").isZero {
            ageMax.text = String(Int(settingDefault.ageMax)) + " ans"
            rangeSlider.upperValue = settingDefault.ageMax
        } else {
            ageMax.text = String(Int(userDefaults.doubleForKey("AgeMaxValue"))) + " ans"
            rangeSlider.upperValue = userDefaults.doubleForKey("AgeMaxValue")
        }
        
                
        /*if ageMax.text == "0"{
            ageMax.text == String(stringInterpolationSegment: Int(rangeSlider.upperValue))
        }
        else {
            ageMax.text = String(stringInterpolationSegment: Int(userDefaults.floatForKey("AgeMaxValue"))) + " ans"
        }*/
        
        //UserData()
        contentViewTest2.addSubview(rangeSlider)
        contentViewTest2.addSubview(ageLabel)

        initCheckmarksCells()
        
        rangeSlider.translatesAutoresizingMaskIntoConstraints = false
        
        print("Bob\(rangeSlider.accessibilityElementCount())")
        
        
        /*let rangeSliderConstraint = NSLayoutConstraint(item: rangeSlider, attribute:
            .TopMargin, relatedBy: .Equal, toItem: ageLabel,
            attribute: .TopMargin, multiplier: 1.0, constant: 20)*/
        
        
        print("get image picture")
       
        
        
        print("profile picture setting")
        //print(UserDataFb().pictureCache.description)

        
    }
    
     override func viewDidLayoutSubviews() {
        //let marginTop: CGFloat = 10.0
        //let marginBottom: CGFloat = 5
        let width = view.bounds.width - 2.0 * 16
        rangeSlider.frame = CGRect(x: 16, y: 27,
            width: width, height: 30.0)
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
    //let FBLogOut = FBSDKLoginManager()
    
    @IBAction func deleteUserAccount(sender: AnyObject) {
        
        PFUser.logOutInBackground()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(vc, animated: true, completion: nil)
        
        /*print("Userdefault\(userDefault.dictionaryRepresentation().keys)")
        
        let email:String = userDefault.stringForKey("email")!
        
        let emailDict:Dictionary<String,String> = ["email": email]
        
        queryServices.post("DELETE", params: emailDict, url: "https://hadrink.herokuapp.com/users/delete") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
            
            if(succeeded) {
                print("Delete account : DONE")
                self.userDefault.removeObjectForKey("email")
                //println(self.userDefault.stringForKey("email"))
                //self.FBLogOut.logOut()
                let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.showViewController(vc as! UIViewController, sender: vc)
            }
            else {
                print("Failed to delete your account. Please try again later.")
            }
        }*/
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
        
        userDefaults.setDouble(rangeSlider.lowerValue, forKey: "AgeMinValue")
        userDefaults.setDouble(rangeSlider.upperValue, forKey: "AgeMaxValue")
        
        ageMin.text = String(stringInterpolationSegment: Int(rangeSlider.lowerValue))
        ageMax.text = String(stringInterpolationSegment: Int(rangeSlider.upperValue)) + " ans"
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        let section = indexPath.section
        
        /*let cellSelected = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: userDefaults.integerForKey("selected_row"), inSection: section))
        cellSelected?.accessoryType = .Checkmark*/
        
        if section == 2 {
        
            let numberOfRows = tableView.numberOfRowsInSection(section)
            for row in 0..<numberOfRows {
                if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) {
                    cell.accessoryType = row == indexPath.row ? .Checkmark : .None
                    userDefaults.setInteger(indexPath.row, forKey: "selected_row")
                    print(userDefaults.integerForKey("selected_row"))
                    print("Selected row")
                    
                }
            }
            
            if monthCheckmarkCell.selected {
                userDefaults.setInteger(31, forKey: "stats_since")
            }
            
            if twoweeksCheckmarkCell.selected {
                userDefaults.setInteger(14, forKey: "stats_since")
            }
            
            if oneweekCheckmarkCell.selected {
                userDefaults.setInteger(7, forKey: "stats_since")
            }
            

        }
    }
    
    
    func initCheckmarksCells(){
        //nomatterCheckmarkCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        let stats_since = userDefaults.integerForKey("stats_since")
        switch(stats_since){
        case 30:
            monthCheckmarkCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            break
        case 14:
            twoweeksCheckmarkCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            break
        case 7:
            oneweekCheckmarkCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            break
        default:
            monthCheckmarkCell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
    }
    
    func designProfileViews() {
        //-- Fill profilePicture & backgroundPicture with the facebook profile picture
        do {
            let currentUserPhoto:PFFile = PFUser.currentUser()?.objectForKey("profile_picture") as! PFFile
            let profilePicture = try UIImage(data: currentUserPhoto.getData())
            
            self.profilePicture.image = profilePicture
            self.backgroundPicture.image = profilePicture
            
        } catch {
            print("Cannot get profile picture")
        }
        
        //-- Add blur on the profile picture views
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.view.backgroundColor = UIColor.clearColor()
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            //always fill the view
            blurEffectView.frame = backgroundPicture.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            backgroundPicture.addSubview(blurEffectView)
        }
        
        //-- Add corner radius on profile picture view
        profilePicture.layer.cornerRadius = 45
        profilePicture.clipsToBounds = true
    }
    
    //-- Avoid Bounce effect
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let panGesture:UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
        let velocity = panGesture.velocityInView(view)
        
        if velocity.x > 0 {
            return true
        } else {
            return false
        }
        
    }
    
}