//
//  MyPosition.swift
//  Status
//
//  Created by Rplay on 16/08/2014.
//  Copyright (c) 2014 Christopher Degas. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation

class MyPosition {
        
    // Outlets
    
    
    

    
    // Button action
    
    
    
    
    

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
        var dataString = "ACTION=REGISTER&LATITUDE=\(lastname.text)&LONGITUDE=\(firstname.text)"
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


}
