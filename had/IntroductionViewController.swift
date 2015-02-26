import UIKit

class IntroductionViewController: ResponsiveTextFieldViewController, UITextFieldDelegate, UIPopoverPresentationControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configView()
        isUserConnected()
        textFieldPsw.delegate = self
       
    }
    
     override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
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
    
    
    @IBOutlet var createAccountLabel: UILabel!
    @IBOutlet var textFacebook: UIButton!
    @IBOutlet var textEmail: UIButton!
    @IBOutlet weak var textFieldMail: UITextField!
    @IBOutlet weak var textFieldPsw: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    @IBAction func withYourFacebook(sender: UIButton) {
    
    }
    
    
    @IBAction func withYourEmail(sender: UIButton) {
    
    }
        
    var methodePost = xmlHttpRequest()
    var myJsonResult = ""

    func textFieldShouldReturn(textField : UITextField) -> Bool{
        
        
        if (textField === textFieldMail) {
            textFieldPsw.becomeFirstResponder()
        }
        
        if(textField === textFieldPsw){
            
            // Correct url and username/password
            methodePost.post(["E-mail": textFieldMail.text, "Password":textFieldPsw.text], url: "http://151.80.128.136:3000/email/user/") { (succeeded: Bool, msg: String) -> () in
                var alert = UIAlertView(title: "Success!", message: msg, delegate: nil, cancelButtonTitle: "Okay.")
                    
                if(succeeded) {
                    alert.title = "Success!"
                    alert.message = msg
                    let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("SWRevealViewController")
                    self.showViewController(vc as UIViewController, sender: vc)
                }
                
                else {
                    alert.title = "Failed :("
                    alert.message = msg
                }
                    
                // Move to the UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // Show the alert
                    alert.show()
                })
            }
                
        return true
            
        }
        
    return false
        
    }
    

    func isUserConnected()
    {
        var user: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("Username")
        if(user != nil){
            let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("ParameterRadarViewController")
            self.showViewController(vc as UIViewController, sender: vc)
        }
    }
    
    func configView()
    {
        
        
        
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
        
        
        textFacebook.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)
                
        textEmail.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)
        
        
        textFacebook.layer.borderColor = greyColor.CGColor
        textFacebook.tintColor = greyColor
        textFacebook.layer.borderWidth = 1.0
        textFacebook.layer.backgroundColor = blueColor.CGColor
        
        textEmail.layer.borderColor = greyColor.CGColor
        textEmail.tintColor = greyColor
        textEmail.layer.borderWidth = 1.0

    
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
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
        var dataString = "ACTION=LOGIN&EMAIL=\(textFieldMail.text)&PASSWORD=\(textFieldPsw.text)"
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
        println(results)
                println(textFieldMail.text)
                println(textFieldPsw.text)
        return results.substringWithRange(sbstring)
    }*/

    
    
}

