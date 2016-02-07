//
//  Tooltip.swift
//  had
//
//  Created by Rplay on 05/02/16.
//  Copyright © 2016 had. All rights reserved.
//


class Annotation {
    func createAnnotation(message : String, postition : CGPoint) -> UIView {
        var labelMessage : UILabel!
        var annotationView : UIView!
        
        let messageSize = message.textSizeWithFont(UIFont(name: "Lato-Italic", size: 14)!, constrainedToSize: CGSize(width: 1000, height: 200))
        
        annotationView = UIView(frame:CGRectMake(0, 0, messageSize + 20, 30))
        labelMessage = UILabel(frame:CGRectMake(0, 0, messageSize, 20))
        labelMessage.font = UIFont(name: "Lato-Italic", size: 14)
        
        labelMessage.text = message
        labelMessage.center = annotationView.center
        annotationView.addSubview(labelMessage as UIView)
        annotationView.center = postition
        annotationView.backgroundColor = UIColor.whiteColor()
        annotationView.layer.shadowColor = UIColor.blackColor().CGColor
        annotationView.layer.shadowOffset = CGSize(width: 1, height: 1)
        annotationView.layer.shadowOpacity = 0.8
        annotationView.layer.cornerRadius = 4
        annotationView.layer.position.x = postition.x + (messageSize / 2)
        annotationView.layer.position.y = postition.y - 10
        
        return annotationView
    }
    
    func removeAnnotation(annotation : UIView) {
            annotation.removeFromSuperview()
    }
}