//
//  viewController.swift
//  had
//
//  Created by Rplay on 09/11/15.
//  Copyright © 2015 had. All rights reserved.
//

import UIKit

let pageController = ViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)

class ViewController: UIPageViewController, UIScrollViewDelegate {
    
    let MainVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController")
//    UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GeotificationViewController")
    let SettingsVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SettingsViewController")
    //let matchesVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MatchesNavController") as! UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for v in self.view.subviews{
            print(v.bounds)
            if v.isKindOfClass(UIScrollView){
                (v as! UIScrollView).delegate = self
            }
        }
        
        view.backgroundColor = UIColor.whiteColor()
        dataSource = self
        setViewControllers([MainVC], direction: .Forward, animated: true, completion: nil)
    }
    
    func goToNextVC() {
        let nextVC = pageViewController(self, viewControllerAfterViewController: viewControllers![0] )!
        setViewControllers([nextVC], direction: .Forward, animated: true, completion: nil)
    }
    
    func goToPreviousVC() {
        let previousVC = pageViewController(self, viewControllerBeforeViewController: viewControllers![0] )!
        setViewControllers([previousVC], direction: .Reverse, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.bounces = false
    }
    
}

// MARK - UIPageViewControllerDataSource
extension ViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController {
        case MainVC:
            return SettingsVC
        case SettingsVC:
            return nil
        //case matchesVC:
            //return cardsVC
        default:
            return nil
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController {
        case MainVC:
            return nil
        case SettingsVC:
            return MainVC
        default:
            return nil
        }
    }
    
}

