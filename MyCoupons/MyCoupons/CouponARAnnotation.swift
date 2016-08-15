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
    
    init(imageURL : String, title: String, location: String, enabledRadius : Int) {
        super.init()
        var locArr : [String] = location.characters.split{$0 == ":"}.map(String.init)
        let lat = Double(locArr[0])!
        let lon = Double(locArr[1])!
        super.location = CLLocation(latitude: lat, longitude: lon)
        super.title = title
        self.imageURL = imageURL
        self.enabledRadius = enabledRadius
    }
}