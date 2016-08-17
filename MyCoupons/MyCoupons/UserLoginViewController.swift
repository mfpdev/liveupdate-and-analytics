//
//  UserLoginViewController.swift
//  MyCoupons
//
//  Created by Ishai Borovoy on 17/08/2016.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import UIKit
import IBMMobileFirstPlatformFoundation

class UserLoginViewController: UIViewController {
    @IBOutlet weak var userNameUITF: UITextField!
    @IBOutlet weak var passwordIUITF: UITextField!
    
    
    @IBAction func login(sender: AnyObject) {
        let userLoginChallenge = WLClient.sharedInstance().getChallengeHandlerBySecurityCheck(UserLoginChallengeHandler.securityCheckName) as! UserLoginChallengeHandler
        if let username = userNameUITF.text, let password = passwordIUITF.text{
            userLoginChallenge.submitChallengeAnswer(["username": username, "password" : password])
        }
    }
}