//
//  Coupon.swift
//  MyCoupons
//
//  Created by Ishai Borovoy on 15/08/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import HDAugmentedReality
import CoreLocation

class CouponARAnnotation: ARAnnotation {
    var imageURL: String?
    var enabledRadius : Int?
    var isPicked: Bool = false
    var couponType : String?
    var couponSegment : String?
    var locationString : String?
    
    init(imageURL : String, title: String, location: String, enabledRadius : Int, couponType: String, segment : String) {
        super.init()
        self.locationString = location
        var locArr : [String] = location.characters.split{$0 == ":"}.map(String.init)
        let lat = Double(locArr[0])!
        let lon = Double(locArr[1])!
        super.location = CLLocation(latitude: lat, longitude: lon)
        super.title = title
        self.imageURL = imageURL
        self.enabledRadius = enabledRadius
        self.couponType = couponType
        self.couponSegment = segment
    }
    
     func asMetaData ()->[NSObject: AnyObject] {
        return ["imageURL" : imageURL!,
                "enabledRadius" : enabledRadius!,
                "couponType" :couponType!,
                "isPicked" : isPicked,
                "couponSegment" : couponSegment!,
                "title" : title!,
                "location" : locationString!,
                "distanceFromUser" : String(round(distanceFromUser))
        ]
    }
}