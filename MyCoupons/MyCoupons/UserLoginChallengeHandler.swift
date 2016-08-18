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
//  UserLoginChallengeHandler.swift
//  MyCoupons
//
//  Created by Ishai Borovoy on 14/08/2016.
//

import IBMMobileFirstPlatformFoundation
import AudioToolbox.AudioServices
import UIKit


public class UserLoginChallengeHandler : SecurityCheckChallengeHandler {
    public static let securityCheckName = "UserLogin"
    var userLoginViewController : UserLoginViewController?
    
    override init() {
        super.init(name: UserLoginChallengeHandler.securityCheckName)
        WLClient.sharedInstance().registerChallengeHandler(self)
    }
    
    override public func handleChallenge(challenge: [NSObject : AnyObject]!) {
        if (userLoginViewController?.loginPressed >= 1) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        showLoginScreen()
    }
    
    public override func handleSuccess(success: [NSObject : AnyObject]!) {
        NSUserDefaults.standardUserDefaults().setObject(success["user"]!["displayName"]!!, forKey: "displayName")
        NSUserDefaults.standardUserDefaults().synchronize()
        closeLoginScreen()
        
    }
    
    public override func handleFailure(failure: [NSObject : AnyObject]!) {
        let alertView = UIAlertView(title: "Login failed", message: "Failed to login, try again later", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        closeLoginScreen()
    }
    
    private func closeLoginScreen () {
        if  self.userLoginViewController != nil && self.userLoginViewController!.isPresented {
            UIApplication.sharedApplication().windows.first?.rootViewController?.dismissViewControllerAnimated(true, completion: {
                
            })
        }
       
    }
    
    private func showLoginScreen () {
        if self.userLoginViewController == nil || !self.userLoginViewController!.isPresented {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.userLoginViewController = storyboard.instantiateViewControllerWithIdentifier("UserLoginViewController") as? UserLoginViewController
            UIApplication.sharedApplication().windows.first?.rootViewController?.presentViewController(self.userLoginViewController!, animated: true, completion: {
                
            })
        }
    }

}