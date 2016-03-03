//
//  RefreshView.swift
//  had
//
//  Created by Rplay on 03/03/16.
//  Copyright © 2016 had. All rights reserved.
//

extension MainViewController
{
    
    func setupRefreshControl() {
        //-- Setup the loading view, which will hold the moving graphics
        self.refreshLoadingView = UIView(frame: self.refreshControl.bounds)
        self.refreshLoadingView.backgroundColor = UIColor.clearColor()
        
        //-- Setup the color view, which will display the rainbowed background
        self.refreshColorView = UIView(frame: self.refreshControl.bounds)
        self.refreshColorView.backgroundColor = UIColor.clearColor()
        self.refreshColorView.alpha = 0.30
        
        //-- Create the graphic image views
        town_background = UIImageView(image: UIImage(named: "pull-to-refresh-bg"))
        
        self.bottle_spinner = UIImageView(image: UIImage(named: "bottle-spin"))
        self.bottle_spinner.frame.size = CGSize(width: 42, height: 42)
        
        //-- Add the graphics to the loading view
        self.refreshLoadingView.addSubview(self.town_background)
        self.refreshLoadingView.addSubview(self.bottle_spinner)
        
        //-- Clip so the graphics don't stick out
        self.refreshLoadingView.clipsToBounds = true;
        
        //-- Hide the original spinner icon
        self.refreshControl.tintColor = UIColor.clearColor()
        
        //-- Add the loading and colors views to our refresh control
        self.refreshControl.addSubview(self.refreshColorView)
        self.refreshControl.addSubview(self.refreshLoadingView)
        
        //-- Initalize flags
        self.isRefreshIconsOverlap = false;
        self.isRefreshAnimating = false;
        
        //-- When activated, invoke our refresh function
        self.refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func refresh(){
        PFAnalytics.trackEventInBackground("RefrechMainView", block: nil)
        
        //-- DO SOMETHING AWESOME (... or just wait 3 seconds)
        //-- This is where you'll make requests to an API, reload data, or process information
        let delayInSeconds = 3.0;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            
            //-- When done requesting/reloading/processing invoke endRefreshing, to close the control
            self.nbAlertDuringRefresh = 0
            self.refreshControl.endRefreshing()
        }
        //-- FINISHED SOMETHING AWESOME, WOO!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //-- Get the current size of the refresh controller
        var refreshBounds = self.refreshControl.bounds;
        
        //-- Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -self.refreshControl.frame.origin.y);
        
        //-- Half the width of the table
        let midX = self.tableData.frame.size.width / 2.0;
        
        //-- Calculate the width and height of our graphics
        let compassHeight = self.town_background.bounds.size.height + 120;
        let compassHeightHalf = compassHeight / 2.0;
        
        let compassWidth = self.town_background.bounds.size.width;
        let compassWidthHalf = compassWidth / 2.0;
        
        let spinnerHeight = self.bottle_spinner.bounds.size.height;
        let spinnerHeightHalf = spinnerHeight / 2.0;
        
        let spinnerWidth = self.bottle_spinner.bounds.size.width;
        let spinnerWidthHalf = spinnerWidth / 2.0;
        
        //-- Calculate the pull ratio, between 0.0-1.0
        //_ = min( max(pullDistance, 0.0), 100.0) / 100.0;
        
        //-- Set the Y coord of the graphics, based on pull distance
        let compassY = pullDistance / 2.0 - compassHeightHalf;
        let spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
        
        //-- Calculate the X coord of the graphics, adjust based on pull ratio
        var compassX = midX + compassWidthHalf - compassWidth;
        var spinnerX = midX - spinnerWidthHalf;
        
        //-- When the compass and spinner overlap, keep them together
        if (fabsf(Float(compassX - spinnerX)) < 1.0) {
            self.isRefreshIconsOverlap = true;
        }
        
        //-- If the graphics have overlapped or we are refreshing, keep them together
        if (self.isRefreshIconsOverlap || self.refreshControl.refreshing) {
            compassX = midX - compassWidthHalf;
            spinnerX = midX - spinnerWidthHalf;
        }
        
        //-- Set the graphic's frames
        var compassFrame = self.town_background.frame;
        compassFrame.origin.x = compassX;
        compassFrame.origin.y = compassY;
        
        var spinnerFrame = self.bottle_spinner.frame;
        spinnerFrame.origin.x = spinnerX;
        spinnerFrame.origin.y = spinnerY;
        
        self.town_background.frame = compassFrame;
        self.bottle_spinner.frame = spinnerFrame;
        
        //-- Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        
        self.refreshColorView.frame = refreshBounds;
        self.refreshLoadingView.frame = refreshBounds;
        
        //-- If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshControl.refreshing && !self.isRefreshAnimating) {
            self.animateRefreshView()
        }
    }
    
    func animateRefreshView() {
        //-- Background color to loop through for our color view
        
        var colorArray = [UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.orangeColor(), UIColor.magentaColor()]
        
        //--  In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
        }
        
        //-- Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animateWithDuration(
            Double(0.3),
            delay: Double(0.0),
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                if(self.nbAlertDuringRefresh == 0){
                    self.isAnimating = self.startLocationManager()
                    self.nbAlertDuringRefresh++
                }
                //-- Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                self.bottle_spinner.transform = CGAffineTransformRotate(self.bottle_spinner.transform, CGFloat(M_PI_2))
                
                //-- Change the background color
                self.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
                ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
            },
            completion: { finished in
                
                //-- If still refreshing, keep spinning, else reset
                if (self.refreshControl.refreshing) {
                    self.animateRefreshView()
                    if(self.isAnimating && self.nbAlertDuringRefresh == 0){
                        self.locationManager.stopUpdatingLocation()
                    }
                    
                } else {
                    self.resetAnimation()
                }
            }
        )
    }
    
    func resetAnimation() {
        
        //-- Reset our flags and }background color
        self.isRefreshAnimating = false;
        self.isRefreshIconsOverlap = false;
        self.refreshColorView.backgroundColor = UIColor.clearColor()
    }
    
}
