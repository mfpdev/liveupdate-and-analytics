//
//  ViewController.swift
//  MyCoupons
//
//  Created by Ishai Borovoy on 14/08/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit
import CoreLocation
import HDAugmentedReality
import IBMMobileFirstPlatformFoundationLiveUpdate
import IBMMobileFirstPlatformFoundation
import SwiftyJSON

class ViewController: UIViewController, ARDataSource{

    var couponsAnnotations : [CouponARAnnotation]? = []
    var enabledRadius : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showCoupons () {
        // Check if device has hardware needed for augmented reality
        let result = ARViewController.createCaptureSession()
        if result.error != nil {
            let message = result.error?.userInfo["description"] as? String
            let alertView = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "Close")
            alertView.show()
            return
        }
        
        // Present ARViewController
        let arViewController = ARViewController()
        arViewController.debugEnabled = false
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 100
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        arViewController.setAnnotations(couponsAnnotations!)
        self.presentViewController(arViewController, animated: true, completion: nil)
    }
    
    @IBAction func getMyCoupons(sender: AnyObject) {
        LiveUpdateManager.sharedInstance.obtainConfiguration("regular") { (configuration, error) in
            if let couponeIsEnable = configuration?.isFeatureEnabled("ar_coupon"){
                if (couponeIsEnable) {
                    if let coupons_adapter_url = configuration?.getProperty("coupons_adapter_url"), let enabledRadius = configuration?.getProperty("enabledRadius") {
                        self.enabledRadius = Int(enabledRadius)
                        self.fertchCoupons(coupons_adapter_url)
                    }
                }
            }
        }
    }
    
    private func fertchCoupons (coupons_adapter_url:String) {
        couponsAnnotations?.removeAll()
        let resourseRequest = WLResourceRequest(URL: NSURL(string:coupons_adapter_url)!, method:"GET")
        resourseRequest.sendWithCompletionHandler({ (response, error) -> Void in
            if let data = response.responseText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                self.appendCouponsFromResponse (data)
                //Show only if there is coupons
                if (self.couponsAnnotations?.count > 0) {
                    self.showCoupons()
                }
            }
        })
    }
    
    private func appendCouponsFromResponse (data : NSData) {
        let coupons = JSON(data: data)
        for (_,couponJSON):(String, JSON) in coupons {
            self.couponsAnnotations?.append(CouponARAnnotation(imageURL: couponJSON["imageURL"].string!, title: couponJSON["title"].string!, location: couponJSON["location"].string!, enabledRadius: self.enabledRadius!))
        }
    }
    
    /// This method is called by ARViewController, make sure to set dataSource property.
    func ar(arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = CouponAnnotationView()
        annotationView.frame = CGRect(x: 0,y: 0,width: 100000 / viewForAnnotation.distanceFromUser,height: 100000 / viewForAnnotation.distanceFromUser)
        return annotationView;
    }
}

