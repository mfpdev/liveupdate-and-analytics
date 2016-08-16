/*
 *    Licensed Materials - Property of IBM
 *    5725-I43 (C) Copyright IBM Corp. 2015, 2016. All Rights Reserved.
 *    US Government Users Restricted Rights - Use, duplication or
 *    disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
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

    static Logger logger = Logger.getLogger(CouponsResource.class.getName());

	@Context
	ConfigurationAPI configApi;

	@ApiOperation(value = "Returns coupons for requested segment (e.g. regular/premium/vip)", notes = "Fake of a resource returning coupons list from the enterprise marketing systems")
	@ApiResponses(value = { @ApiResponse(code = 200, message = "Hello message returned") })
	@GET
	@Produces(MediaType.APPLICATION_JSON)
    @Path("{segment}")
    @OAuthSecurity (scope = "club-member-scope")
	public Coupon [] getCoupons(@PathParam("segment") String segment) {
        Coupon [] coupons = new Coupon[0];
        JSONArray json = new JSONArray();
	    if (segment.equals("regular")) {
            coupons = new Coupon[]{
                    new Coupon ("regular", "20% Coupon","https://pixabay.com/static/uploads/photo/2016/05/30/14/13/twenty-percent-off-1424812_960_720.png","32.249196:34.841903", Coupon.CouponType.DISCOUNT),
                    new Coupon ("regular", "35% Coupon","https://pixabay.com/static/uploads/photo/2016/05/30/14/20/thirty-five-percent-off-1424826_960_720.png","32.225630:34.841251",Coupon.CouponType.DISCOUNT),
                    new Coupon ("regular", "40% Coupon","https://pixabay.com/static/uploads/photo/2016/05/30/14/13/forty-percent-off-1424816_960_720.png","32.216586:34.822409",Coupon.CouponType.DISCOUNT),
                    new Coupon ("regular", "$3 Gift Card","https://pixabay.com/static/uploads/photo/2015/08/11/08/31/coupon-883647_960_720.jpg","32.317815:34.858460",Coupon.CouponType.DISCOUNT)
            };
		} else if (segment.equals("premium")){
            coupons = new Coupon[]{
                    new Coupon ("premium", "30% Coupon","https://pixabay.com/static/uploads/photo/2015/10/31/12/21/discount-1015446_960_720.jpg","32.162413:34.844675",Coupon.CouponType.DISCOUNT),
                    new Coupon ("premium", "30% Coupon","https://pixabay.com/static/uploads/photo/2015/10/31/12/21/discount-1015446_960_720.jpg","32.321458:34.853196",Coupon.CouponType.DISCOUNT),
                    new Coupon ("premium", "40% Coupon","https://pixabay.com/static/uploads/photo/2015/10/31/12/21/discount-1015445_960_720.jpg","32.216586:34.822409",Coupon.CouponType.DISCOUNT),
                    new Coupon ("premium", "OnePlusOne","https://pixabay.com/static/uploads/photo/2016/05/30/14/13/forty-percent-off-1424816_960_720.png","32.228477:34.824411",Coupon.CouponType.GIFT),
                    new Coupon ("premium", "$5 Gift Card","https://pixabay.com/static/uploads/photo/2016/05/30/14/13/forty-percent-off-1424816_960_720.png","32.321458:34.853196",Coupon.CouponType.GIFT)
            };
		} else if (segment.equals("vip")){
			coupons = new Coupon[]{
                    new Coupon ("vip", "60% Coupon","https://pixabay.com/static/uploads/photo/2016/02/01/09/30/sixty-1173253_960_720.jpg","32.216586:34.822409", Coupon.CouponType.DISCOUNT),
                    new Coupon ("vip", "$10 Gift card","https://pixabay.com/static/uploads/photo/2015/08/11/08/21/coupon-883638_960_720.png","32.228477:34.824411",Coupon.CouponType.GIFT),
                    new Coupon ("vip", "New iPhone Gift!!!","https://pixabay.com/static/uploads/photo/2014/09/23/21/22/iphone-6-458155_960_720.jpg","32.220675:34.819579", Coupon.CouponType.GIFT)
            };
		}
		return coupons;
	}
}
