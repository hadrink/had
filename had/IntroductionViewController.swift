import UIKit
import CoreData

/*class IntroductionViewController: ResponsiveTextFieldViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate{
    
    let QServices = QueryServices()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeProfileChange", name:FBSDKProfileDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeTokenChange", name:FBSDKAccessTokenDidChangeNotification, object: nil)
        
        configView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var greyColor:UIColor = UIColor(red: 0.949, green: 0.945, blue: 0.939, alpha: 1)
    
    var greyColorTrans:UIColor = UIColor(red: 0.949, green: 0.945, blue: 0.939, alpha: 0.3)
    
    var blueColor:UIColor = UIColor(red: (59/255.0), green: (89/255.0), blue: (152/255.0), alpha: 0.6)
    
    var redColor:UIColor = UIColor(red: (247/255.0), green: (101/255.0), blue: (67/255.0), alpha: 1)
    
    var whiteColor :UIColor = UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 1)
    
//    let MyKeychainWrapper = KeychainWrapper()
    
   // @IBOutlet var createAccountLabel: UILabel!


/*    @IBOutlet var textEmail: UIButton!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var textFieldPsw: UITextField!*/
    //@IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var buttleHad: UIImageView!
    @IBOutlet weak var backgroundIntro: UIImageView!

    //var methodePost = QueryServices()
    //var myJsonResult = ""

    /*
    func textFieldShouldReturn(textField : UITextField) -> Bool{
        
        if (textField === textFieldMail) {
            textFieldPsw.becomeFirstResponder()
        }
        
        if(textField === textFieldPsw)
        {
            if (textFieldPsw.text == "" || textFieldMail.text == "") {
                let alert = UIAlertView()
                alert.title = "You must enter both a username and password!"
                alert.addButtonWithTitle("Oops!")
                alert.show()
                return false;
            }

            // 2.
            textFieldMail.resignFirstResponder()
            textFieldPsw.resignFirstResponder()
            

                // 6.
            checkLogin(textFieldMail.text!, password: textFieldPsw.text!)
                
            return true
        }
        
        return false
    }
    
    func checkLogin(username: String, password: String ) -> Bool
    {
        if password == MyKeychainWrapper.myObjectForKey("v_Data") as? NSString &&
            username == NSUserDefaults.standardUserDefaults().valueForKey("username") as? NSString {
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                NSUserDefaults.standardUserDefaults().synchronize()
                let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
                self.showViewController(vc as! UIViewController, sender: vc)
                return true
        } else {
            methodePost.post("POST", params: ["E-mail": username, "Password":password], url: "http://151.80.128.136:3000/email/user/") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                let alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                
                if(succeeded) {
                    alert.title = "Success!"
                    alert.message = msg
                    let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
                    if hasLoginKey == false {
                        NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
                    }
                    
                    self.MyKeychainWrapper.mySetObject(password, forKey:kSecValueData)
                    self.MyKeychainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    //var pwd = self.MyKeychainWrapper.myObjectForKey("v_Data") as! NSString
                    
                    let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
                    self.showViewController(vc as! UIViewController, sender: vc)
                }
                else {
                    alert.title = "Login Problem"
                    alert.message = "Wrong username or password."
                    alert.addButtonWithTitle("Foiled Again!")
                }
                
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                    alert.show()
                })
            }
            return true
        }
    }
*/
    /*func isUserConnected()
    {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Username")
        if(user != nil){
            let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("ParameterRadarViewController")
            self.showViewController(vc as! UIViewController, sender: vc)
        }
    }*/
    
    func configView()
    {
        /*textFieldPsw.delegate = self
        //textFieldMail.textColor = whiteColor
        textFieldMail.placeholder = "E-mail / Nom d'utilisateur"
        textFieldMail.font = UIFont(name: "Lato-Light", size: 12)
        textFieldMail.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor
        
        var paddingTextFieldMail:UIView = UIView(frame: CGRectMake(0, 0, 10, 0))
        
        textFieldMail.leftView = paddingTextFieldMail
        textFieldMail.leftViewMode = UITextFieldViewMode.Always



        
        //textFieldPsw.textColor = whiteColor
        textFieldPsw.placeholder = "Mot de passe"
        textFieldPsw.font = UIFont(name: "Lato-Light", size: 12)
        textFieldPsw.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor
        
        var paddingTextFieldPsw:UIView = UIView(frame: CGRectMake(0, 0, 10, 0))
        
        textFieldPsw.leftView = paddingTextFieldPsw
        textFieldPsw.leftViewMode = UITextFieldViewMode.Always
        
        
        //textFacebook.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)
                
        textEmail.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)
        
        
        textEmail.layer.borderColor = greyColor.CGColor
        textEmail.tintColor = greyColor
        textEmail.layer.borderWidth = 1.0

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    */
        
        facebookBtn.layer.borderColor = greyColor.CGColor
        facebookBtn.tintColor = greyColor
        facebookBtn.layer.borderWidth = 1.0
        facebookBtn.layer.backgroundColor = blueColor.CGColor
        facebookBtn.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        
    }
    
    @IBAction func btnFBLoginPressed(sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile","email","user_friends"], handler: { (result, error) -> Void in
            if (error == nil){
                
                if result.isCancelled {
                    print(" Handle cancellations")
                }
                else {
                    // If you ask for multiple permissions at once, you
                    // should check if specific permissions missing
                    if result.grantedPermissions.contains("email")
                    {
                        UserDataFb().SendUserData()
                        
                        var vc: AnyObject!
                        vc=self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
                        self.showViewController(vc as! UIViewController, sender: vc)
                        print(" Do work")
                    }
                }
            }
        })
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func observeProfileChange(){
        if ((FBSDKProfile.currentProfile()) != nil) {
            print("diff de nil")
            var vc: AnyObject!
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
            self.showViewController(vc as! UIViewController, sender: vc)
        }
    }
    
    func observeTokenChange(){
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            print("profile change")
            observeProfileChange()
        }
    }*/


    class LoginViewController: UIViewController{
        
        @IBOutlet weak var facebookBtn: UIButton!
        @IBOutlet weak var buttleHad: UIImageView!
        @IBOutlet weak var backgroundIntro: UIImageView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
        }
        
        @IBAction func loginButtonPressed(sender: UIButton) {
            PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
                user, error in
                
                if user == nil {
                    print("Ruh-roh, the user cancelled the Facebook login.")
                    return
                } else if user!.isNew {
                    print("User just signed up and logged in for the first time.")
                    
                    let FBRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me?fields=picture,first_name,birthday,gender", parameters: nil)
                    FBRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                        
                        let r = result as! NSDictionary
                        
                        user!["firstName"] = r["first_name"]
                        user!["gender"] = r["gender"]
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        user!["birthDay"] = dateFormatter.dateFromString(r["birthday"] as! String)
                        
                        let pictureURL = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary) ["url"] as! String
                        let url = NSURL(string: pictureURL)
                        let request = NSURLRequest(URL: url!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                            response, data, error in
                            
                            let imageFile = PFFile(name: "avatar.jpg", data: data!)
                            user!["picture"] = imageFile
                            user!.saveInBackgroundWithBlock(nil)
                        })
                    })
                } else {
                    print("User logged in through Facebook.")
                }
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController")
                self.presentViewController(vc, animated: true, completion: nil)
            })
        }
        
    }



