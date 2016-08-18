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
//  UserLoginViewController.swift
//  MyCoupons
//
//  Created by Ishai Borovoy on 14/08/2016.
//

import Foundation
import UIKit
import IBMMobileFirstPlatformFoundation

class UserLoginViewController: UIViewController {
    @IBOutlet weak var userNameUITF: UITextField!
    @IBOutlet weak var passwordIUITF: UITextField!
    var loginPressed = 0;
    var isPresented = false
    
    override func viewWillAppear(animated: Bool) {
        loginPressed = 0
        isPresented = true
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        isPresented = false
    }
    
    @IBAction func login(sender: AnyObject) {
        loginPressed += 1
        let userLoginChallenge = WLClient.sharedInstance().getChallengeHandlerBySecurityCheck(UserLoginChallengeHandler.securityCheckName) as! UserLoginChallengeHandler
        if let username = userNameUITF.text, let password = passwordIUITF.text{
            userLoginChallenge.submitChallengeAnswer(["username": username, "password" : password])
        }
    }
}