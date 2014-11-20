//
//  ContainerViewController.swift
//  had
//
//  Created by Chris Degas on 20/11/2014.
//  Copyright (c) 2014 had. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation

enum SlideOutState {
        case BothCollapsed
        case LeftPanelExpanded
}
    
class ContainerViewController: UIViewController, CenterViewControllerDelegate, UIGestureRecognizerDelegate,CLLocationManagerDelegate {
        var centerNavigationController: UINavigationController!
        var centerViewController: CenterViewController!
        let locationManager = CLLocationManager()
        var currentState: SlideOutState = .BothCollapsed {
            didSet {
                let shouldShowShadow = currentState != .BothCollapsed
                showShadowForCenterViewController(shouldShowShadow)
            }
        }
        //leftController
        var leftViewController: SidePanelViewController?

        
        let centerPanelExpandedOffset: CGFloat = 60
        
        override init() {
            super.init(nibName: nil, bundle: nil)
        }
        
        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()

            locationManager.requestAlwaysAuthorization()
            centerViewController = UIStoryboard.centerViewController()
            centerViewController.delegate = self
            
            // wrap the centerViewController in a navigation controller, so we can push views to it
            // and display bar button items in the navigation bar
            centerNavigationController = UINavigationController(rootViewController: centerViewController)
            view.addSubview(centerNavigationController.view)
            addChildViewController(centerNavigationController)
            
            centerNavigationController.didMoveToParentViewController(self)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
            centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        }
        
        // MARK: CenterViewController delegate methods
        
        func toggleLeftPanel() {
            let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
            
            if notAlreadyExpanded {
                addLeftPanelViewController()
            }
            
            animateLeftPanel(shouldExpand: notAlreadyExpanded)
        }
    
        func collapseSidePanels() {
            switch (currentState) {
            case .LeftPanelExpanded:
                toggleLeftPanel()
            default:
                break
            }
        }
        
        func addLeftPanelViewController() {
            if (leftViewController == nil) {
                leftViewController = UIStoryboard.leftViewController()
                leftViewController!.informations = Information.allInformations()
                
                addChildSidePanelController(leftViewController!)
            }
        }
        
        func addChildSidePanelController(sidePanelController: SidePanelViewController) {
            sidePanelController.delegate = centerViewController
            
            view.insertSubview(sidePanelController.view, atIndex: 0)
            
            addChildViewController(sidePanelController)
            sidePanelController.didMoveToParentViewController(self)
        }
        
        func animateLeftPanel(#shouldExpand: Bool) {
            if (shouldExpand) {
                currentState = .LeftPanelExpanded
                
                animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
            } else {
                animateCenterPanelXPosition(targetPosition: 0) { finished in
                    self.currentState = .BothCollapsed
                    
                    self.leftViewController!.view.removeFromSuperview()
                    self.leftViewController = nil;
                }
            }
        }
    
        func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                self.centerNavigationController.view.frame.origin.x = targetPosition
                }, completion: completion)
        }
        
        func showShadowForCenterViewController(shouldShowShadow: Bool) {
            if (shouldShowShadow) {
                centerNavigationController.view.layer.shadowOpacity = 0.8
            } else {
                centerNavigationController.view.layer.shadowOpacity = 0.0
            }
        }
        
        // MARK: Gesture recognizer
        
        func handlePanGesture(recognizer: UIPanGestureRecognizer) {
            // we can determine whether the user is revealing the left or right
            // panel by looking at the velocity of the gesture
            let gestureIsDraggingFromLeftToRight = (recognizer.velocityInView(view).x > 0)
            
            switch(recognizer.state) {
            case .Began:
                if (currentState == .BothCollapsed) {
                    // If the user starts panning, and neither panel is visible
                    // then show the correct panel based on the pan direction
                    
                    if (gestureIsDraggingFromLeftToRight) {
                        addLeftPanelViewController()
                    }

                    showShadowForCenterViewController(true)
                }
            case .Changed:
                // If the user is already panning, translate the center view controller's
                // view by the amount that the user has panned
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                recognizer.setTranslation(CGPointZero, inView: view)
            case .Ended:
                // When the pan ends, check whether the left or right view controller is visible
                if (leftViewController != nil) {
                    // animate the side panel open or closed based on whether the view has moved more or less than halfway
                    let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                    animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
                }
            default:
                break
            }
        }
    }
    
    private extension UIStoryboard {
        class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
        
        class func leftViewController() -> SidePanelViewController? {
            return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
        }
        
        class func centerViewController() -> CenterViewController? {
            return mainStoryboard().instantiateViewControllerWithIdentifier("CenterViewController") as? CenterViewController
        }
}