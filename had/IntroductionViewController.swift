import UIKit

class IntroductionViewController: UIViewController, UITextFieldDelegate{
    
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
    
    
    func textFieldShouldReturn(textField : UITextField) -> Bool{
        
        
        /*if textField == textFieldPsw {
            
            var dataString = "ACTION=LOGIN&EMAIL=\(textFieldMail.text)&PASSWORD=\(textFieldPsw.text)"
            var xhr = xmlHttpRequest()
            var caramel:NSString = xhr.methodPost(dataString)

            
            println(caramel)
            
            if caramel == "done" {
                let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("ParameterRadarViewController")
                self.showViewController(vc as UIViewController, sender: vc)
            }
            
            else {
                textFieldMail.layer.borderColor = redColor.CGColor
                textFieldMail.layer.borderWidth = 4.0
            }
        }*/
        
        return true
        
        
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
        textFieldMail.font = UIFont(name: "Lato-Regular", size: 18)
        textFieldMail.layer.cornerRadius = 4
        
        //textFieldPsw.textColor = whiteColor
        textFieldPsw.placeholder = "Mot de passe"
        textFieldPsw.font = UIFont(name: "Lato-Regular", size: 18)
        textFieldPsw.layer.cornerRadius = 4
        
        
        textFacebook.titleLabel?.font = UIFont(name: "Lato-Regular", size: 18)
                
        textEmail.titleLabel?.font = UIFont(name: "Lato-Regular", size: 18)
        
        
        textFacebook.layer.cornerRadius = 4
        textFacebook.layer.borderColor = greyColor.CGColor
        textFacebook.tintColor = greyColor
        textFacebook.layer.borderWidth = 2.0
        textFacebook.layer.backgroundColor = blueColor.CGColor
        
        textEmail.layer.cornerRadius = 4
        textEmail.layer.borderColor = greyColor.CGColor
        textEmail.tintColor = greyColor
        textEmail.layer.borderWidth = 2.0
    
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
