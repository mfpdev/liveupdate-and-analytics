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
//  CouponARAnnotation.swift
//  MyCoupons
//
//  Created by Ishai Borovoy on 14/08/2016.
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
                "isPicked" : isPicked ? "true" : "false",
                "couponSegment" : couponSegment!,
                "title" : title!,
                "location" : locationString!,
                "distanceFromUser" : String(round(distanceFromUser))
        ]
    }
}