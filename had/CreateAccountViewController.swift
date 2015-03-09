import UIKit
import CoreData

class CreateAccountViewController: ResponsiveTextFieldViewController, UITextFieldDelegate{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = UIColor .orangeColor()
        configView()
        
        
        //navigationBar.barTintColor = UIColor(red: 66/255, green: 86/255, blue: 114/255, alpha: 1)
        
        func UIColorFromRGB(rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        }
        
        navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Lato-Bolditalic", size: 18)!, NSForegroundColorAttributeName: UIColorFromRGB(0xffffff)]
        
        navigationBar.barTintColor = UIColorFromRGB(0x546a85)
        navigationBar.translucent = false
              
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        configView()
        
        // Notifications for keyboard
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidHide:"), name: UIKeyboardDidHideNotification, object: nil)
        */
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    var greyColor:UIColor = UIColor(red: 0.949, green: 0.945, blue: 0.939, alpha: 1)
    
    var greyTransColor:UIColor = UIColor(red: 0.949, green: 0.945, blue: 0.939, alpha: 0.3)
    
    var yellow:UIColor = UIColor(red: (247/255.0), green: (195/255.0), blue: (111/255.0), alpha: 1)
    
    var orange:UIColor = UIColor(red: (244/255.0), green: (180/255.0), blue: (103/255.0), alpha: 1)
    
    var blueColor:UIColor = UIColor(red: (59/255.0), green: (89/255.0), blue: (152/255.0), alpha: 1)
    
    var greyColorForm:UIColor = UIColor(red: (242/255.0), green: (242/255.0), blue: (242/255.0), alpha: 1)
    
    var darkColor:UIColor = UIColor(red: (106/255.0), green: (106/255.0), blue: (105/255.0), alpha: 1)
    
    var redColor:UIColor = UIColor(red: (247/255.0), green: (101/255.0), blue: (67/255.0), alpha: 1)
    
    
    @IBOutlet var lastname: UITextField!
    @IBOutlet var firstname: UITextField!
    @IBOutlet var mail: UITextField!
    @IBOutlet var pwd: UITextField!
    @IBOutlet var confirmationPwd: UITextField!
    @IBOutlet var birthdate: UIDatePicker!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var birthdateButton: UIButton!
    @IBOutlet var datePickerView: UIView!
    @IBOutlet var datePickerToolbar: UIToolbar!
    @IBOutlet var toolbarButton: UIBarButtonItem!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var navigationBar: UINavigationBar!
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        //animationDown()
        
    }
    
   
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        if (textField === lastname) {
            firstname.becomeFirstResponder()
            return false
        }
        
        if (textField === firstname) {
            mail.becomeFirstResponder()
            return false
        }
        if (textField === mail) {
            pwd.becomeFirstResponder()
            return false
        }
        
        if (textField === pwd) {
            confirmationPwd.becomeFirstResponder()
            return false
        }
        
        if (textField === confirmationPwd) {
            birthdateButton.becomeFirstResponder()
            return true
        }
        
        
        return true
    }
    
    
    
    @IBAction func lastnameEditingEnd(sender: AnyObject) {
        
        if  lastname.text.isEmpty {
            lastname.text = "Ce champ est vide"
            lastname.textColor = redColor
        }
        else if lastname.text.isEmpty == false {
            lastname.textColor = darkColor
        }

    }
    
    @IBAction func lastnameEditingBegin(sender: UITextField, forEvent event: UIEvent) {
        
        
        lastname.text = ""
        lastname.textColor = darkColor
        
        
    }
    
    
    @IBAction func firstnameEditingBegin(sender: AnyObject){
        
        firstname.text = ""
        firstname.textColor = darkColor
    }
    
    @IBAction func firstnameEditingEnd(sender: AnyObject) {
        if  firstname.text.isEmpty {
            firstname.text = "Ce champ est vide"
            firstname.textColor = redColor
        }
        else if firstname.text.isEmpty == false {
            firstname.textColor = darkColor
        }
    
    }
    
    
    @IBAction func emailEditingEnd(sender: AnyObject) {
        
        func validateEmail (candidate:NSString) -> Bool{
            
            var emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
            var emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            
            return emailTest!.evaluateWithObject(candidate)
        }
        
        if  mail.text.isEmpty {
            mail.text = "Ce champ est vide"
            mail.textColor = redColor
        }
        
        if(!validateEmail(mail.text)){
            mail.text = "Cette adresse n'est pas valide"
            mail.textColor = redColor
        }
        else {
            mail.textColor = darkColor
            
        }
        /*var emailTest:Dictionary<String,String> = ["E-mail": mail.text]

        methodePost.post(emailTest, url: "http://151.80.128.136:3000/email/user/") { (succeeded: Bool, msg: String) -> () in
            var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
            
            var myEmailfield = self.mail.text
            
            if(succeeded) {
                alert.title = "Cette adresse existe déjà"
                alert.message = msg
                myEmailfield = "Cette adresse existe déjà"
            }
            
            // Move to the UI thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // Show the alert
                alert.show()
            })
        }*/
        
        if  mail.text.isEmpty {
            mail.text = "Ce champ est vide"
            mail.textColor = redColor
        }
    }
    
    var oneConstraint:NSLayoutConstraint!

    
    func addConstraints(contraints : NSLayoutConstraint){
        
        var myConstraintsAdded: Void = self.view.addConstraint(contraints)
        
        return(myConstraintsAdded)
    }
    
    func removeConstraints(constraints : NSLayoutConstraint){
        var myConstraintsRemoved:Void = self.view.removeConstraint(constraints)
        
        return(myConstraintsRemoved)
    }
    
    
    @IBAction func emailEditingBegin(sender: AnyObject) {
        mail.text = ""
        mail.textColor = darkColor
        
        
    }
    
    
    @IBAction func passwordEditingEnd(sender: AnyObject) {
        var lenght = countElements(pwd.text!)
        if (lenght < 8 || lenght > 12){
            pwd.secureTextEntry = false
            pwd.text = "Mot de passe entre 8 et 12 ;)"
            pwd.textColor = redColor
        }
    }
    
    
    @IBAction func passwordEditingBegin(sender: AnyObject) {
        
        pwd.secureTextEntry = true
        pwd.text = ""
        pwd.textColor = darkColor
        
        
    }

    
    @IBAction func confirmPasswordEditingBegin(sender: AnyObject) {
        
        confirmationPwd.secureTextEntry = true
        confirmationPwd.text = ""
    }
    
    
    @IBAction func confirmPasswordEditingEnd(sender: AnyObject) {
        if(pwd.text != confirmationPwd.text){
            confirmationPwd.secureTextEntry = false
            confirmationPwd.text = "Tu t'es gouré Coco"
            confirmationPwd.textColor = redColor
           //animationDown()
        }
        
    }

    @IBAction func birthdateButtonTouch(sender: UIButton) {
        
        UIView.animateWithDuration(0.4, animations: {
            
            self.datePickerView.frame = CGRectMake(0.0, self.view.frame.size.height - self.datePickerView.frame.height, self.view.frame.width, 250.0)
        })
        
    }
    
    func checkUserData() -> Bool {
        var bool = false
        
        if ( !firstname.text.isEmpty && !lastname.text.isEmpty && !mail.text.isEmpty && !pwd.text.isEmpty && !confirmationPwd.text.isEmpty){
            bool = true
        }
        
        
        return bool
    }
    
    var methodePost = xmlHttpRequest()
    
    @IBAction func sendUserData(sender: UIButton) {
        
        if (checkUserData()){
            var finalGender:String = gender.titleForSegmentAtIndex(gender.selectedSegmentIndex)!
            
            var tabUser:Dictionary<String,String> = ["Lastname": lastname.text, "Firstname": firstname.text, "E-mail": mail.text, "Password" : pwd.text, "Birthdate" : birthdate.date.description, "Gender" : finalGender ]
            
            var url = "http://151.80.128.136:3000/user/"
            //methodePost.post(tabUser, url:URLS.urlUser)
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            appDelegate.userProfil.saveUserCoreData(firstname.text, lastname: lastname.text, mail: mail.text, gender: gender.selectedSegmentIndex, birthDate: birthdate.date)
            
            println("http://151.80.128.136:3000/user/\(mail.text)")
            
            methodePost.post(tabUser, url: "http://151.80.128.136:3000/user/\(mail.text)") { (succeeded: Bool, msg: String) -> () in
                var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                
                if(succeeded) {
                    alert.title = "Create Account Success!"
                    alert.message = msg
                    let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
                    self.showViewController(vc as UIViewController, sender: vc)
                }
                    
                else {
                    alert.title = "Cet E-mail est déjà utilisé :("
                    alert.message = msg
                }
                
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                    alert.show()
                })
            }
            println("Create Account : Success");


        }
        
        else {
            println("Create Account : Failed");
        }
        
    }
    
    
    @IBAction func toolbarButtonDone(sender: UIBarButtonItem) {
        

        UIView.animateWithDuration(0.4, animations: {
            
            self.datePickerView.frame = CGRectMake(0.0, self.view.frame.size.height, self.view.frame.width, 250.0)
            
        },
        
            completion: { finished in
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                self.birthdateButton.setTitle(dateFormatter.stringFromDate(self.birthdate.date), forState: UIControlState.Normal)
        
        })
        
        
        
    }
   
    
    
    func configView()
    {
        
        // Color
        
        let blackColorOpacity = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor
        let greyColorTrans:UIColor = UIColor(red: 0.949, green: 0.945, blue: 0.939, alpha: 0.4)

        
        // Padding left
        
        let paddingTextFieldLastname:UIView = UIView(frame: CGRect(x: 0,y: 0,width: 10,height: 20))
        let paddingTextFieldFirstname:UIView = UIView(frame: CGRect(x: 0,y: 0,width: 10,height: 20))
        let paddingTextFieldMail:UIView = UIView(frame: CGRect(x: 0,y: 0,width: 10,height: 20))
        let paddingTextFieldPwd:UIView = UIView(frame: CGRect(x: 0,y: 0,width: 10,height: 20))
        let paddingTextFieldconfirmPwd:UIView = UIView(frame: CGRect(x: 0,y: 0,width: 10,height: 20))
        
        lastname.leftView = paddingTextFieldLastname
        lastname.leftViewMode = UITextFieldViewMode.Always
        firstname.leftView = paddingTextFieldFirstname
        firstname.leftViewMode = UITextFieldViewMode.Always
        mail.leftView = paddingTextFieldMail
        mail.leftViewMode = UITextFieldViewMode.Always
        confirmationPwd.leftView = paddingTextFieldconfirmPwd
        confirmationPwd.leftViewMode = UITextFieldViewMode.Always
        pwd.leftView = paddingTextFieldPwd
        pwd.leftViewMode = UITextFieldViewMode.Always
        
        
        // Shadows
        
        // Create Account Button
        
        createAccountButton.layer.borderColor = greyColor.CGColor
        createAccountButton.tintColor = greyColor
        createAccountButton.layer.borderWidth = 1.0
        
        // Lastname
        
        lastname.placeholder = "Prénom"
        lastname.layer.backgroundColor = blackColorOpacity

        
        // Firstname
        
        firstname.placeholder = "Prénom"
        firstname.layer.backgroundColor = blackColorOpacity

        
        // E-mail
        
        mail.placeholder = "E-mail"
        mail.layer.backgroundColor = blackColorOpacity
        
        
        // Password
        
        pwd.placeholder = "Mot de passe"
        pwd.layer.backgroundColor = blackColorOpacity
        
        // Confirmation Password
        
        confirmationPwd.placeholder = "Confirmation"
        confirmationPwd.layer.backgroundColor = blackColorOpacity
        
        // Birthdate 
        
        birthdateButton.layer.backgroundColor = blackColorOpacity
        birthdateButton.tintColor = greyColorTrans
        
        // Gender
        
        gender.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor
        
        
    }
}

