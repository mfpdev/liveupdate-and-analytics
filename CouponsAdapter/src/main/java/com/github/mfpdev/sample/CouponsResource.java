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

import com.ibm.json.java.JSONArray;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Logger;

import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import com.ibm.mfp.adapter.api.ConfigurationAPI;
import com.ibm.mfp.adapter.api.OAuthSecurity;

@Api(value = "Sample Adapter Resource")
@Path("/")
public class CouponsResource {
    private static final String REGULAR = "regular";
    private static final String PREMIUM = "premium";
    private static final String VIP = "vip";

    private final static String BASE_URL = "https://raw.githubusercontent.com/mfpdev/liveupdate-and-analytics/master/images/";

    @Context
    ConfigurationAPI configurationAPI;


    private static double STORE_LATITUDE = 32.216586;
    private static double STORE_LONGITUDE =  34.822409;

	@ApiOperation(value = "Returns coupons for requested segment (e.g. regular/premium/vip)", notes = "Fake of a resource returning coupons list from the enterprise marketing systems")
	@ApiResponses(value = { @ApiResponse(code = 200, message = "Hello message returned") })
	@GET
	@Produces(MediaType.APPLICATION_JSON)
    @Path("{segment}")
    @OAuthSecurity (scope = "club-member-scope")
	public Coupon [] getCoupons(@PathParam("segment") String segment) {
        String lat = configurationAPI.getPropertyValue("LATITUDE");
        String lon = configurationAPI.getPropertyValue("LONGITUDE");
        if (!lat.isEmpty() && !lon.isEmpty()) {
            STORE_LATITUDE = Double.valueOf(configurationAPI.getPropertyValue("LATITUDE"));
            STORE_LONGITUDE = Double.valueOf(configurationAPI.getPropertyValue("LONGITUDE"));
        }

        Coupon [] coupons = new Coupon[0];
	    if (segment.equals(REGULAR)) {
            coupons = new Coupon[]{
                    getCoupon (REGULAR, 30, Coupon.CouponType.DISCOUNT),
                    getCoupon (REGULAR, 30, Coupon.CouponType.DISCOUNT),
                    getCoupon (REGULAR, 30, Coupon.CouponType.DISCOUNT),
                    getCoupon (REGULAR, 50, Coupon.CouponType.DISCOUNT),
                    getCoupon (REGULAR, 5, Coupon.CouponType.GIFT)
            };
		} else if (segment.equals(PREMIUM)){
            coupons = new Coupon[]{
                    getCoupon (PREMIUM, 30, Coupon.CouponType.DISCOUNT),
                    getCoupon (PREMIUM, 50, Coupon.CouponType.DISCOUNT),
                    getCoupon (PREMIUM, 50, Coupon.CouponType.DISCOUNT),
                    getCoupon (PREMIUM, 50, Coupon.CouponType.DISCOUNT),
                    getCoupon (PREMIUM, 5, Coupon.CouponType.GIFT),
                    getCoupon (PREMIUM, 5, Coupon.CouponType.GIFT)
            };
		} else if (segment.equals(VIP)){
			coupons = new Coupon[]{
                    getCoupon (VIP, 30, Coupon.CouponType.DISCOUNT),
                    getCoupon (VIP, 50, Coupon.CouponType.DISCOUNT),
                    getCoupon (VIP, 50, Coupon.CouponType.DISCOUNT),
                    getCoupon (VIP, 50, Coupon.CouponType.DISCOUNT),
                    getCoupon (VIP, 50, Coupon.CouponType.DISCOUNT),
                    getCoupon (VIP, 70, Coupon.CouponType.DISCOUNT),
                    getCoupon (VIP, 70, Coupon.CouponType.DISCOUNT),
                    getCoupon (VIP, 5, Coupon.CouponType.GIFT),
                    getCoupon (VIP, 5, Coupon.CouponType.GIFT),
                    getCoupon (VIP, 10, Coupon.CouponType.GIFT),
                    getCoupon (VIP, 10, Coupon.CouponType.GIFT),
                    getCoupon (VIP, 10, Coupon.CouponType.GIFT)
            };
		}
		return coupons;
	}

	private String getRandomLocationNearStore () {
        double lat = Math.random() / 100;
        double lon = Math.random() / 100;
        return (STORE_LATITUDE + lat) + ":" + (STORE_LONGITUDE + lon);
    }

    private Coupon getCoupon (String memberType, int sum, Coupon.CouponType couponType) {
        String title = couponType == Coupon.CouponType.DISCOUNT ? sum + "% Discount" : "$" + sum + " Gift";
        String imageUrl = BASE_URL + sum + (couponType == Coupon.CouponType.DISCOUNT ? "-discount.png" : "-gift.png");
        return new Coupon(memberType, title, imageUrl , getRandomLocationNearStore (), couponType);
    }
}
