//
//  CollectionView.swift
//  had
//
//  Created by Rplay on 03/02/16.
//  Copyright © 2016 had. All rights reserved.
//
import UIKit

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    //-- Return number of cells in CollectionView
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        
            collectionView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0)
            var indexPath: NSIndexPath?
            if let superview = collectionView.superview {
                if let cell = superview.superview as? PlaceCell {
                    indexPath = tableData.indexPathForCell(cell)
                    print("Index Path Row \(indexPath?.row)")
                    if indexPath != nil {
                        if isFavOn {
                            print(searchArray[indexPath!.row].friends)
                        }
                        let friendsCount:Int? = isFavOn ? searchArray[indexPath!.row].friends?.count : placeItems[indexPath!.row].friends?.count
                        if isFavOn {
                            print(searchArray[indexPath!.row])
                        }
                        print(isFavOn)
                        return friendsCount != nil ? friendsCount! : 0
                    }
                    
                }
            }
            return 0
    }
    
    //-- Action when tapping on cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var indexPathTableView: NSIndexPath
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell",
            forIndexPath: indexPath)
        let frame = collectionView.convertRect(cell.frame, toView: self.view)
        
        if let superview = collectionView.superview {
            if let tableViewCell = superview.superview as? PlaceCell {
                
                indexPathTableView = tableData.indexPathForCell(tableViewCell)!
                
                var friends = isFavOn ? searchArray[indexPathTableView.row].friends : placeItems[indexPathTableView.row].friends
                let userId = indexPath.row
                let FBRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "\(friends![userId])?fields=picture,first_name,last_name,birthday,gender", parameters: nil)
                
                FBRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                    
                    let r = result as! NSDictionary
                    let firstName:String = String(r["first_name"]!)
                    let lastName:String = String(r["last_name"]!)
                    let fullName = firstName + " " + lastName
                    let tooltip = Annotation().createAnnotation(fullName, postition: frame.origin)
                    
                    tooltip.alpha = 0
                    self.view.addSubview(tooltip)
                    
                    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                        tooltip.alpha = 0.9
                        }, completion: {
                            (finished: Bool) -> Void in
                            
                            // Fade in
                            UIView.animateWithDuration(0.5, delay: 2.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                                tooltip.alpha = 0.0
                                }, completion: {
                                    (finished: Bool) -> Void in
                                    if finished {
                                        Annotation().removeAnnotation(tooltip)
                                    }
                                })
                            
                    })
                    
                })
                
            }
        }
        
    }
    
    //-- Return UICollectionViewCell
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            
            var indexPathTableView: NSIndexPath
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell",
                forIndexPath: indexPath)
            let fbImageView:UIImageView = UIImageView()
            
            fbImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            fbImageView.layer.cornerRadius = fbImageView.frame.size.width / 2
            fbImageView.layer.masksToBounds = true
            
            
            if let superview = collectionView.superview {
                if let tableViewCell = superview.superview as? PlaceCell {
                    indexPathTableView = tableData.indexPathForCell(tableViewCell)!
                    var friends = isFavOn ? searchArray[indexPathTableView.row].friends : placeItems[indexPathTableView.row].friends
                    let userId = indexPath.row
                    
                    let url: NSURL! = NSURL(string: "https://graph.facebook.com/\(friends![userId])/picture?width=90&height=90")
                    let request:NSURLRequest = NSURLRequest(URL:url)
                    let queue:NSOperationQueue = NSOperationQueue()
                    
                    NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ response, data, error in
                        
                        //-- Check if response != nil
                        if((response) != nil) {
                            
                            //-- Lunch async request in main queue for UI elements
                            dispatch_async(dispatch_get_main_queue()) {
                                fbImageView.image = UIImage(data: data!)
                            }
                        }
                    })
                    
                    cell.addSubview(fbImageView)
                    
                }
            }
            
        return cell
    }
}

