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

import com.google.gson.Gson;
import com.ibm.mfp.server.app.external.ApplicationKey;
import com.ibm.mfp.server.registration.external.model.AuthenticatedUser;
import com.ibm.mfp.server.registration.external.model.DeviceData;
import com.ibm.mfp.server.registration.external.model.RegistrationData;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.HashMap;
import java.util.List;
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

@Api(value = "Club member resolver adapter")
@Path("/")
public class ClubMemberTypeSegmentResolverResource {
	private static final Gson gson = new Gson();
	private static final Logger logger = Logger.getLogger(ResolverAdapterData.class.getName());


	@POST
	@Path("segment")
	@Produces("text/plain;charset=UTF-8")
	@OAuthSecurity(scope = "configuration-user-login")
	public String getSegment(String body) throws Exception {
		ResolverAdapterData data = gson.fromJson(body, ResolverAdapterData.class);
		String segmentName = "";

		// Get the authenticatedUser object
		AuthenticatedUser authenticatedUser = data.getAuthenticatedUser();

		char firstCharacter = authenticatedUser.getDisplayName().charAt(0);

		boolean isPremiumMember = firstCharacter >= 'I' && firstCharacter <= 'Q' || firstCharacter >= 'i' && firstCharacter <= 'q';
		boolean isVIPMember = firstCharacter >= 'R' && firstCharacter <= 'Z' || firstCharacter >= 'r' && firstCharacter <= 'z';

		return isVIPMember ? "vip" : isPremiumMember ? "premium"  : "regular";
	}

}

