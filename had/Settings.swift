//
//  Settings.swift
//  had
//
//  Created by chrisdegas on 07/04/2015.
//  Copyright (c) 2015 had. All rights reserved.
//

import UIKit


class Settings {
    
    //Properties
    class var defaultSettings : Settings {
        struct Singleton {
            // lazily initiated, thread-safe from "let"
            static let instance = Settings()
        }
        return Singleton.instance
    }
    
    lazy var kShouldSkipLoginKey:NSString = "shouldSkipLogin";
    
    func shouldSkipLogin() -> Bool
    {
        return NSUserDefaults.standardUserDefaults().boolForKey(kShouldSkipLoginKey as String)
    }
    
    func setShouldSkipLogin(shouldSkipLogin:Bool)
    {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(shouldSkipLogin ,forKey:kShouldSkipLoginKey as String)
        defaults.synchronize()
    }
    
}
