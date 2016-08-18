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
package com.github.mfpdev.sample;

public class Coupon {
    private String title;
    private String imageURL;
    private String location;

    public String getCouponSegment() {
        return couponSegment;
    }

    public void setCouponSegment(String couponSegment) {
        this.couponSegment = couponSegment;
    }

    private String couponSegment;

    private CouponType couponType;

    enum CouponType {
        DISCOUNT,
        GIFT
    }

    public Coupon(String couponSegment, String title, String imageURL, String location, CouponType couponType) {
        this.title = title;
        this.imageURL = imageURL;
        this.location = location;
        this.couponType = couponType;
        this.couponSegment = couponSegment;
    }

    public String getTitle() {
        return title;
    }

    public CouponType getCouponType() {
        return couponType;
    }

    public void setCouponType(CouponType couponType) {
        this.couponType = couponType;
    }

    public void setTitle(String name) {
        this.title = name;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
