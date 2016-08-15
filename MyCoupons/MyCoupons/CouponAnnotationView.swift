//
//  TestAnnotationView.swift
//  HDAugmentedRealityDemo
//
//  Created by Danijel Huis on 30/04/15.
//  Copyright (c) 2015 Danijel Huis. All rights reserved.
//

import UIKit
import HDAugmentedReality

public class CouponAnnotationView: ARAnnotationView, UIGestureRecognizerDelegate
{
    var couponImageView : UIImageView?
    
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
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.layer.cornerRadius = 5
        
        if self.annotation != nil {
            self.bindUi()
        }
    }
    
    func layoutUi() {
        let size: CGFloat =  CGFloat(100000 / (self.annotation as! CouponARAnnotation).distanceFromUser)
        self.couponImageView?.frame = CGRectMake(0, 0,size, size)
    }
    
    // This method is called whenever distance/azimuth is set
    override public func bindUi() {
        if let annotation = self.annotation{
            let distance = annotation.distanceFromUser > 1000 ? String(format: "%.1fkm", annotation.distanceFromUser / 1000) : String(format:"%.0fm", annotation.distanceFromUser)
            
            let text = String(format: "AZ: %.0f°\nDST: %@", annotation.azimuth, distance)
            print (text)
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
        }
    }
}
