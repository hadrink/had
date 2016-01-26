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
    let SettingsVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SettingsViewController")
    //let matchesVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MatchesNavController") as! UIViewController
    
    @IBOutlet var scrollViewPanGestureRecognizer: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*for value in view.subviews {
            if let view = value as? UIScrollView {
                let panGestureRecognizer:UIPanGestureRecognizer = view.panGestureRecognizer

                panGestureRecognizer.addTarget(self, action: "move:")
            }
        }*/
        
        /*for view in self.view.subviews {
            if view.isKindOfClass(UIScrollView) {
                let scrollView:UIScrollView = view as! UIScrollView
                self.scrollViewPanGestureRecognizer = UIPanGestureRecognizer()
                self.scrollViewPanGestureRecognizer.delegate = self
            }
        }*/
        
        view.backgroundColor = UIColor.whiteColor()
        dataSource = self
        setViewControllers([MainVC], direction: .Forward, animated: true, completion: nil)
    }
    
    
    
    /*func move(gesture : UIPanGestureRecognizer) {
            var velocity : CGPoint = gesture.velocityInView(MainVC.view)
            var truc = gesture.locationInView(MainVC.view)
        
            gestureRecognizerShouldBegin(gesture)
            if(velocity.x > 0){
                print("Panning down")
                gesture.cancelsTouchesInView = false
            }
            //Pan Up
            if(velocity.x < 0 ){
                gesture.cancelsTouchesInView = true
            }
        
            
            print(truc)
            print(velocity)
        
    }*/
    
   /* func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("Proute")
        return false
    }*/
    
    func goToNextVC() {
        let nextVC = pageViewController(self, viewControllerAfterViewController: viewControllers![0] )!
        setViewControllers([nextVC], direction: .Forward, animated: true, completion: nil)
    }
    
    func goToPreviousVC() {
        let previousVC = pageViewController(self, viewControllerBeforeViewController: viewControllers![0] )!
        setViewControllers([previousVC], direction: .Reverse, animated: true, completion: nil)
        
    }
    
    /*func scrollViewDidScroll(scrollView: UIScrollView) {
            scrollView.bounces = false

            scrollView.delegate = self
            //scrollView.pagingEnabled = true
    }*/
    
    
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

