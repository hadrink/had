import UIKit
import CoreData

class IntroductionViewController: ResponsiveTextFieldViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate,FBSDKLoginButtonDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeProfileChange", name:FBSDKProfileDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeTokenChange", name:FBSDKAccessTokenDidChangeNotification, object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            observeTokenChange()
            //returnUserData();
            println("token yes")
            // User is already logged in, do work such as go to next view controller.
            returnUserData()
        }
        else
        {
            println("token no")
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
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
    
    let MyKeychainWrapper = KeychainWrapper()
    
    @IBOutlet var createAccountLabel: UILabel!


    @IBOutlet var textEmail: UIButton!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var textFieldPsw: UITextField!
    @IBOutlet weak var loginLabel: UILabel!

    var methodePost = xmlHttpRequest()
    var myJsonResult = ""

    
    func textFieldShouldReturn(textField : UITextField) -> Bool{
        
        if (textField === textFieldMail) {
            textFieldPsw.becomeFirstResponder()
        }
        
        if(textField === textFieldPsw)
        {
            if (textFieldPsw.text == "" || textFieldMail.text == "") {
                var alert = UIAlertView()
                alert.title = "You must enter both a username and password!"
                alert.addButtonWithTitle("Oops!")
                alert.show()
                return false;
            }

            // 2.
            textFieldMail.resignFirstResponder()
            textFieldPsw.resignFirstResponder()
            

                // 6.
            checkLogin(textFieldMail.text, password: textFieldPsw.text)
                
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
            methodePost.post(["E-mail": username, "Password":password], url: "http://151.80.128.136:3000/email/user/") { (succeeded: Bool, msg: String, obj : NSDictionary) -> () in
                var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                
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
                    var pwd = self.MyKeychainWrapper.myObjectForKey("v_Data") as! NSString
                    
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
        textFieldPsw.delegate = self
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
        
        
       /* textFacebook.layer.borderColor = greyColor.CGColor
        textFacebook.tintColor = greyColor
        textFacebook.layer.borderWidth = 1.0
        textFacebook.layer.backgroundColor = blueColor.CGColor
        */
        textEmail.layer.borderColor = greyColor.CGColor
        textEmail.tintColor = greyColor
        textEmail.layer.borderWidth = 1.0

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            println(" Process error")
        }
        else if result.isCancelled {
            println(" Handle cancellations")
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                var vc: AnyObject!
                vc=self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
                self.showViewController(vc as! UIViewController, sender: vc)
                println(" Do work")
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                println("User Email is: \(userEmail)")
            }
        })
    }
    
    func observeProfileChange(){
        if ((FBSDKProfile.currentProfile()) != nil) {
            println("diff de nil")
            returnUserData()
            var vc: AnyObject!
            vc = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
            self.showViewController(vc as! UIViewController, sender: vc)
        }
    }
    
    func observeTokenChange(){
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            println("profile change")
            observeProfileChange()
        }
    }
}

