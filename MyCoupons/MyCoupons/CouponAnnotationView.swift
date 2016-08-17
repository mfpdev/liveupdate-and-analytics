//
//  TestAnnotationView.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 30/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit
import HDAugmentedReality
import IBMMobileFirstPlatformFoundation

public class CouponAnnotationView: ARAnnotationView, UIGestureRecognizerDelegate
{
    var couponImageView : UIImageView?
    public var titleLabel: UILabel?
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.couponImageView == nil {
            self.loadUi()
        }
    }
    
    func getUIImage (urlString: String)->UIImage? {
        let url = NSURL(string: urlString)
        let imagedData = NSData(contentsOfURL: url!)!
        return UIImage(data: imagedData, scale: 10)
    }
    
    func loadUi() {
        self.titleLabel?.removeFromSuperview()
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(20)
        label.numberOfLines = 0
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        self.addSubview(label)
        self.titleLabel = label
        
        self.couponImageView?.removeFromSuperview()
        let coupon : CouponARAnnotation = self.annotation as! CouponARAnnotation
        let image = coupon.imageURL!.containsString("/") ? getUIImage(coupon.imageURL!) : UIImage(named: coupon.imageURL!)
        let imageView = UIImageView(image: image!)
        self.addSubview(imageView)
        self.couponImageView = imageView
        
        // Gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CouponAnnotationView.couponTapped))
        self.addGestureRecognizer(tapGesture)
        
        // Other
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
        self.layer.cornerRadius = 5
        
        if self.annotation != nil {
            self.bindUi()
        }
    }
    
    func layoutUi() {
        let calculatedSize = CGFloat(200000 / (self.annotation as! CouponARAnnotation).distanceFromUser)
        let size: CGFloat = calculatedSize < 80 ? 80 : calculatedSize > 250 ? 250 : calculatedSize
        self.couponImageView?.frame = CGRectMake(20, 20, size, size)
        self.titleLabel?.frame = CGRectMake(0, 0, self.frame.size.width, 17);
    }
    
    // This method is called whenever distance/azimuth is set
    override public func bindUi() {
        if let annotation = self.annotation{
            let distance = annotation.distanceFromUser > 1000 ? String(format: "%.1fkm", annotation.distanceFromUser / 1000) : String(format:"%.0fm", annotation.distanceFromUser)
            self.titleLabel?.text = distance
            print (distance)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutUi()
    }
    
    public func couponTapped() {
        if let annotation = self.annotation as? CouponARAnnotation  {
            
            if annotation.distanceFromUser > Double(annotation.enabledRadius!) {
                let alertView = UIAlertView(title: annotation.title, message: "Coupon is too far, you need to get closer", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            } else if !annotation.isPicked{
                (self.annotation as! CouponARAnnotation).imageURL = "check.png"
                loadUi()
            }
            WLAnalytics.sharedInstance().log("coupon-not-picked", withMetadata: annotation.asMetaData());
            WLAnalytics.sharedInstance().send();
        }
        
    }
}
