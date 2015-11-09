//
//  viewController.swift
//  had
//
//  Created by Rplay on 08/11/15.
//  Copyright © 2015 had. All rights reserved.
//

import UIKit

let pageController = ViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)

class ViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    let cardsVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainViewController")
    let profileVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SettingView")
    //let matchesVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MatchesNavController")
    
    var currentIndex:NSInteger?
    var nextIndex:NSInteger = 0
    var lastPosition:CGFloat = 0.0
    var pageControl:UIPageControl?
    var shouldBounce:Bool = false
    var pages : Array<UIViewController>?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages = [cardsVC, profileVC]
        
        self.shouldBounce = false
        
        print("view Did Load")
        
        for v in self.view.subviews{
            print(v.bounds)
            if v.isKindOfClass(UIScrollView){
                print("in the if")
                (v as! UIScrollView).delegate = self
            }
        }
        
        for gR in self.gestureRecognizers {
            print("gR")
            gR.delegate = self
        }
        
        view.backgroundColor = UIColor.whiteColor()
        dataSource = self
        delegate = self
    
        setViewControllers([pages![0]], direction: .Forward, animated: false, completion: nil)
        
        
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        print("index for page")
        return self.currentIndex!
    }
    
    func goToNextVC() {
        let nextVC = pageViewController(self, viewControllerAfterViewController: self )!
        setViewControllers([nextVC], direction: .Forward, animated: true, completion: nil)
    }
    
    func goToPreviousVC() {
        let previousVC = pageViewController(self, viewControllerBeforeViewController: viewControllers![0] )!
        setViewControllers([previousVC], direction: .Reverse, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.bounces = false
    }
    
    
    /*
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        var controller = pendingViewControllers.first
        self.nextIndex = (viewControllers?.indexOf(controller!))!
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("scroll View End")
        var minXOffSet:CGFloat = scrollView.bounds.size.width - (CGFloat(self.currentIndex!) * scrollView.bounds.size.width)
        var maxXOffset = (((CGFloat((viewControllers?.count)!)) - CGFloat(self.currentIndex!)) * scrollView.bounds.size.width)
        
        if (!self.shouldBounce) {
            if scrollView.contentOffset.x <= minXOffSet {
                targetContentOffset.memory = CGPointMake(minXOffSet, 0)
            }
                
            else if scrollView.contentOffset.x >= maxXOffset {
                targetContentOffset.memory = CGPointMake(maxXOffset, 0)
            }
        }
        
    }*/
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        print(currentIndex)
        switch viewController {
        case cardsVC:
            return profileVC
        case profileVC:
            return nil
            //case matchesVC:
            //return cardsVC
        default:
            return nil
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        print(currentIndex)
        switch viewController {
        case cardsVC:
            return nil
        case profileVC:
            return cardsVC
        default:
            return nil
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if(finished) {
            print("Zoubida")
            self.currentIndex = (viewControllers?.indexOf(pageViewController.viewControllers![0]))!
            self.pageControl?.currentPage = self.currentIndex!
        }
        
        self.nextIndex = self.currentIndex!
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        print("Pan gesture")
        if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer) {
            print("Pan gesture if")
            let point:CGPoint = touch.locationInView(self.view)
            if(point.x < 100 || point.x > 924) {
                return false
            }
        }
        
        return true
    }
    
    
    
}

// MARK - UIPageViewControllerDataSource


    





