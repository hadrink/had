//
//  CheckConnexion.swift
//  had
//
//  Created by Rplay on 05/02/16.
//  Copyright © 2016 had. All rights reserved.
//

import SystemConfiguration

class ActivityIndicator: NSObject {
    
    var myActivityIndicator:UIActivityIndicatorView!
    var imageConnexionFailed:UIImageView!
    
    func StartActivityIndicator(obj:UIViewController) {
        
        if (Reachability.isConnectedToNetwork() == false) {
            
            imageConnexionFailed = UIImageView(frame: CGRectMake(40, 50, 100, 80))
            imageConnexionFailed.image = UIImage(named: "wifi-icon")
            obj.view.center.y = (obj.view.frame.height / 2) - 100
            imageConnexionFailed.center = obj.view.center
            obj.view.addSubview(imageConnexionFailed)
            
        } else {
            
            self.myActivityIndicator = UIActivityIndicatorView(frame:CGRectMake(100, 100, 100, 100)) as UIActivityIndicatorView
            self.myActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            self.myActivityIndicator.center = obj.view.center
            obj.view.addSubview(self.myActivityIndicator)
            self.myActivityIndicator.startAnimating()
            
        }
    }
    
    func StopActivityIndicator(obj:UIViewController,indicator:UIActivityIndicatorView)-> Void {
        
        indicator.removeFromSuperview();
        
    }
    
    
}

public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        var flags = SCNetworkReachabilityFlags()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        
        }
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            
            return false
            
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}

