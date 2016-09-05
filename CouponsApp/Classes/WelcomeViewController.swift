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
//  WelcomeViewController.swift
//  MyCoupons
//
//  Created by Ishai Borovoy on 14/08/2016.
//

import UIKit
import CoreLocation
import HDAugmentedReality
import IBMMobileFirstPlatformFoundationLiveUpdate
import IBMMobileFirstPlatformFoundation
import SwiftyJSON

class WelcomeViewController: UIViewController, ARDataSource{
    
    @IBOutlet weak var welcomeTitle: UILabel!
    @IBOutlet weak var welcomeImage: UIImageView!
    @IBOutlet weak var clubImage: UIImageView!
    @IBOutlet weak var lookForCouponsFeature: UIButton!
    
    var discountPickableRadius : Int?
    var couponsAnnotations : [CouponARAnnotation]? = []
    var giftPickableRadius : Int?

    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.hidden = true;
        loadWelcomeSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startCouponsAnimation () {
        var imageArray = Array<UIImage>()
        for index in 0...5{
            let imageName = "store_" + String(index) + ".png"
            imageArray.append(UIImage(named: imageName)!)
        }
        self.welcomeImage.animationImages = imageArray
        self.welcomeImage.animationDuration = 3
        self.welcomeImage.animationRepeatCount = 1
        self.welcomeImage.startAnimating()
    }
    
    private func loadWelcomeSettings () {
        LiveUpdateManager.sharedInstance.obtainConfiguration([:]) { (configuration, error) in
            if let couponeIsEnable = configuration?.isFeatureEnabled("ar_coupon") {
                self.lookForCouponsFeature.hidden = !couponeIsEnable
                self.welcomeTitle.text = "Welcome " + NSUserDefaults.standardUserDefaults().stringForKey("displayName")!
                if let clubImage = configuration?.getProperty("clubImage") {
                    self.clubImage.image = Utils.getUIImage(clubImage)!
                }
                if (couponeIsEnable) {
                    if let welcomeMessage = configuration?.getProperty("welcomeMessage") {
                        self.welcomeTitle.text = self.welcomeTitle.text! + ", \n" + welcomeMessage
                    }
                    self.welcomeImage.image = UIImage(named:"store_5.png")
                    self.startCouponsAnimation()
                } else {
                    self.welcomeImage.image = UIImage(named:"store_0.png")
                }
            }
        }
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
        arViewController.maxVerticalLevel = 3
        arViewController.headingSmoothingFactor = 0.05
        arViewController.trackingManager.userDistanceFilter = 100
        arViewController.trackingManager.reloadDistanceFilter = 75
        arViewController.setAnnotations(couponsAnnotations!)
        self.presentViewController(arViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func browseProducts(sender: AnyObject) {
        //Dummy action, only fetch token
        WLAuthorizationManager.sharedInstance().obtainAccessTokenForScope("club-member-scope") { (token, error) in
            if (token != nil) {
                print (token.value)
                self.loadWelcomeSettings ()
            } else {
                print (error)
            }
        }
    }
    
    @IBAction func getMyCoupons(sender: AnyObject) {
        LiveUpdateManager.sharedInstance.obtainConfiguration([:]) { (configuration, error) in
            if let coupons_adapter_url = configuration?.getProperty("coupons_adapter_url"), let discountPickableRadius = configuration?.getProperty("discountPickableRadius"), let giftPickableRadius = configuration?.getProperty("giftPickableRadius") {
                self.discountPickableRadius = Int(discountPickableRadius)
                self.giftPickableRadius = Int(giftPickableRadius)
                self.fertchCoupons(coupons_adapter_url)
                
                let segment = coupons_adapter_url.componentsSeparatedByString("/").last
                WLAnalytics.sharedInstance().log("load-coupons-pressed", withMetadata: ["load-coupons-pressed" : segment!]);
                WLAnalytics.sharedInstance().send();
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
            let couponType = couponJSON["couponType"].string!
            let enableRadius = couponType == "DISCOUNT" ? self.discountPickableRadius : self.giftPickableRadius;
            
            self.couponsAnnotations?.append(CouponARAnnotation(imageURL: couponJSON["imageURL"].string!, title: couponJSON["title"].string!, location: couponJSON["location"].string!, enabledRadius: enableRadius!, couponType: couponType, segment: couponJSON["couponSegment"].string!))
        }
    }
    
    /// This method is called by ARViewController, make sure to set dataSource property.
    func ar(arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = CouponAnnotationView()
        annotationView.frame = CGRect(x: 0,y: 0,width: 200, height: 200)
        return annotationView;
    }
}

