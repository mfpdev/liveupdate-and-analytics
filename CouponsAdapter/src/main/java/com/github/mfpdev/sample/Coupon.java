package com.github.mfpdev.sample;

/**
 * Created by ishaib on 15/08/2016.
 */
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
