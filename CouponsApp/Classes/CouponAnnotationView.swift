/**
 * Copyright 2016 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  CouponAnnotationView.swift
//  MyCoupons
//
//  Created by Ishai Borovoy on 14/08/2016.
//

import UIKit
import HDAugmentedReality
import IBMMobileFirstPlatformFoundation
import AudioToolbox.AudioServices

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
        let image = coupon.imageURL!.containsString("/") ? Utils.getUIImage(coupon.imageURL!) : UIImage(named: coupon.imageURL!)
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
        let calculatedSize = CGFloat(50000 / (self.annotation as! CouponARAnnotation).distanceFromUser)
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
                AudioServicesPlaySystemSound(1306)
                 (self.annotation as! CouponARAnnotation).isPicked = false
                alertView.show()
            } else if !annotation.isPicked{
                AudioServicesPlaySystemSound(1109)
                (self.annotation as! CouponARAnnotation).imageURL = "check.png"
                (self.annotation as! CouponARAnnotation).isPicked = true
                loadUi()
            }
            WLAnalytics.sharedInstance().log("picked-coupon", withMetadata: annotation.asMetaData());
            WLAnalytics.sharedInstance().send();
        }
    }
}
