import UIKit

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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidShow:"), name: UIKeyboardDidShowNotification, object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardDidHide:"), name: UIKeyboardDidHideNotification, object: nil)
        
        
        
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
    
    
    func keyboardWillShow() {
        
       /* UIView.animateWithDuration(0.4, animations: {
            
            var frame:CGRect = self.contentView.frame
            var positionFrame = frame.origin.y
            positionFrame = 200
            
        })*/
        
        
       
        
        /*let dict:NSDictionary = sender.userInfo as NSDictionary!
        let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue;
        let rect :CGRect = s.CGRectValue();
        
        var frame = self.contentView.frame;
        
        //Adjust 80 according to your need actually if is for padding and quickTypeView
        var offset = (rect.height - ((self.view.frame.height - self.contentView.frame.origin.y)+self.contentView.frame.size.height))+80;
        print(offset)
        frame.origin.y = offset>0 ? frame.origin.y - offset : frame.origin.y ;
        UIView.animateWithDuration(0.3, animations:{
            self.contentView.frame = frame;
            
            }
        )*/
        
                
    }
    
    func keyboardDidShow(notifaction: NSNotification) {
        
        
       /* println("Keyboard appeared")
        contentView.layer.position.y = 200
        println(contentView.layer.position.y)
        println(view.frame.height)*/
        //contentView.layer.position.y = 200
        
        /*var info:NSDictionary = notifaction.userInfo!
        
        var kbFrame:NSValue = info.valueForKey("UIKeyboardFrameEndUserInfoKey") as NSValue
        
        var keyboardFrame:CGRect = kbFrame.CGRectValue()
        
        contentView.layer.position.y = contentView.layer.position.y - keyboardFrame.height
        
        println(contentView.layer.position.y)
        
        println(keyboardFrame.height)*/
        

        

    }
    
    
    func keyboardDidHide(notifaction: NSNotification) {

        
        /*println("Keyboard hidden")
        contentView.layer.position.y += 200*/
    }
    
   
    
    @IBAction func createAccount(sender: UIButton) {
        
        /*let user = User(mail: "maurice@mail.com", pwd: "mdp", gend: "Homme", birth: NSDate.date())
        let user2 = User(mail: "maurice@mail.com", pwd: "mdp", gend: "Homme", birth: NSDate.distantPast() as NSDate)*/
        if(lastname.text.isEmpty && firstname.text.isEmpty && mail.text.isEmpty && pwd.text.isEmpty && confirmationPwd.text.isEmpty){
            println("T'as rien rempli sac à merde !")
            
        }
        else if(lastname.textColor == redColor || firstname.textColor == redColor || mail.textColor == redColor || pwd.textColor == redColor || confirmationPwd.textColor == redColor){
            println("Regarde tu t'es gouré !")
            
        }
        /*else{
            var dataString = "ACTION=REGISTER&LASTNAME=\(lastname.text)&FIRSTNAME=\(firstname.text)&EMAIL=\(mail.text)&PASSWORD=\(pwd.text)&BIRTHDATE=\(birthdate.date)&SEX=\(gender.titleForSegmentAtIndex(gender.selectedSegmentIndex)!)"
            var xhr = xmlHttpRequest()
            var registered = xhr.methodPost(dataString)
            println(registered)
            if registered == "done" {
                var user: User = User(mail: mail.text, pwd: pwd.text, gend: "Homme", birth: NSDate())
                //var data:NSData = NSKeyedArchiver.archivedDataWithRootObject(user)
                //var username:NSString  = mail.text
                //var age:NSString  = user.getAge().description
                //NSUserDefaults.standardUserDefaults().setObject(data, forKey:"Username")
                //NSUserDefaults.standardUserDefaults().setObject(age, forKey:"Age")
                NSUserDefaults.standardUserDefaults().synchronize()
                let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("ParameterRadarViewController")
                self.showViewController(vc as UIViewController, sender: vc)
            }
            
        }*/
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
        
        if(!validateEmail(mail.text)){
            mail.text = "Cette adresse n'est pas valide"
            mail.textColor = redColor
        }
        else {
            mail.textColor = darkColor
        }
        
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
    
    /*func animationDown(){
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            
            /*var contentTopFrame = self.contentView.frame
            contentTopFrame.origin.y -= contentTopFrame.size.height
            
            self.contentView.frame = contentTopFrame*/
            
            /* self.view.addConstraint(NSLayoutConstraint(
            item:self.contentView, attribute:.Top,
            relatedBy:.Equal, toItem:self.navigationBar,
            attribute:.Bottom, multiplier:2, constant:20))
            
            self.contentView.frame.origin.y = 80*/
            
            self.removeConstraints(self.oneConstraint)
            
            }, completion: { finished in
                println("Textfield is Down")
        })

    }*/
    
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
        
        /*func move() {
        datePickerTest.layer.anchorPoint = CGPoint(x:1, y:1)
            datePickerTest.layer.position = CGPoint(x:view.frame.width, y: view.frame.height)
        
        }*/
        
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
            methodePost.post(tabUser, url:url)
            
            let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
            self.showViewController(vc as UIViewController, sender: vc)

        }
        
    }
    
    
    @IBAction func toolbarButtonDone(sender: UIBarButtonItem) {
        
        
        /*UIView.animateWithDuration(0.4, animations: {
            
            var frame:CGRect = self.datePickerView.frame
            self.view.frame.size.height + 300.0 + 84
            self.datePickerView.frame = frame
            
        })
        
        var birthdate:String = datePickerTest.date.description
        birthdateButton.setTitle(birthdate, forState: UIControlState.Normal)*/
        
        
        

        UIView.animateWithDuration(0.4, animations: {
            
            self.datePickerView.frame = CGRectMake(0.0, self.view.frame.size.height, self.view.frame.width, 250.0)
            
        },
        
            completion: { finished in
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                self.birthdateButton.setTitle(dateFormatter.stringFromDate(self.birthdate.date), forState: UIControlState.Normal)
        
        })
        
        
        
    }
   
    
       /*func methodPost () -> NSString{
        let url = NSURL(string:"http://www.hadrink.com/had/php/server.php")
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
    
        // set Content-Type in HTTP header
        let boundaryConstant = "----------V2ymHFg03esomerandomstuffhbqgZCaKO6jy";
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        NSURLProtocol.setProperty(contentType, forKey: "Content-Type", inRequest: request)
    
        // set data
        var dataString = "ACTION=REGISTER&LASTNAME=\(lastname.text)&FIRSTNAME=\(firstname.text)&EMAIL=\(mail.text)&PASSWORD=\(pwd.text)&BIRTHDATE=\(birthdate.date)&SEX=\(gender.titleForSegmentAtIndex(gender.selectedSegmentIndex))"
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
    
        // set content length
        NSURLProtocol.setProperty(requestBodyData.length, forKey: "Content-Length", inRequest: request)
    
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
    
        let results = NSString(data:reply, encoding:NSUTF8StringEncoding)
        println("API Response: \(results)")
        var sbstring: NSRange = NSRange(location: 10, length: 4)
        return results.substringWithRange(sbstring)
    }*/
    
    
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
        
        
      /*  //lastname.backgroundColor = greyColorForm
        lastname.textColor = darkColor
        //lastname.font = UIFont(name: "Lato-Regular", size: 14)
        lastname.layer.cornerRadius = 4
        lastname.layer.borderColor = greyColorForm.CGColor
        lastname.layer.borderWidth = 2.0


        
        firstname.backgroundColor = greyColorForm
        firstname.textColor = darkColor
        //firstname.font = UIFont(name: "Lato-Regular", size: 14)
        firstname.layer.cornerRadius = 4
        firstname.layer.borderColor = greyColorForm.CGColor
        firstname.layer.borderWidth = 2.0

        
        mail.backgroundColor = greyColorForm
        mail.textColor = darkColor
        //mail.font = UIFont(name: "Lato-Regular", size: 14)
        mail.layer.cornerRadius = 4
        mail.layer.borderColor = greyColorForm.CGColor
        mail.layer.borderWidth = 2.0

        
        pwd.backgroundColor = greyColorForm
        pwd.textColor = darkColor
        //pwd.font = UIFont(name: "Lato-Regular", size: 14)
        pwd.layer.cornerRadius = 4
        pwd.layer.borderColor = greyColorForm.CGColor
        pwd.layer.borderWidth = 2.0

        
        confirmationPwd.backgroundColor = greyColorForm
        confirmationPwd.textColor = darkColor
        //confirmationPwd.font = UIFont(name: "Lato-Regular", size: 14)
        confirmationPwd.layer.cornerRadius = 4
        confirmationPwd.layer.borderColor = greyColorForm.CGColor
        confirmationPwd.layer.borderWidth = 2.0
        
        birthdate.backgroundColor = greyColorForm
        
        //textLabelBirthdate.textColor = darkColor
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)*/
        
    }
    

}

