package com.github.mfpdev.sample;

/**
 * Created by ishaib on 15/08/2016.
 */
public class Coupon {
    private String title;
    private String imageURL;
    private String location;

    public Coupon(String title, String imageURL, String location) {
        this.title = title;
        this.imageURL = imageURL;
        this.location = location;
    }

    public String getTitle() {
        return title;
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
