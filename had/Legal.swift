//
//  Legal.swift
//  had
//
//  Created by Rplay on 07/02/16.
//  Copyright © 2016 had. All rights reserved.
//

import Foundation

class Legal : UIViewController {

    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.barTintColor = Colors().lightBlue
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let localfilePath = NSBundle.mainBundle().URLForResource("legal", withExtension: "html");
        let request = NSURLRequest(URL: localfilePath!);
        webView.loadRequest(request);
    }
}