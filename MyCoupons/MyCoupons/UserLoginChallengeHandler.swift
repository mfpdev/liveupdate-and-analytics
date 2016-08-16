import IBMMobileFirstPlatformFoundation


public class UserLoginChallengeHandler : SecurityCheckChallengeHandler {
    
    override init() {
        super.init(name: "UserLogin")
        WLClient.sharedInstance().registerChallengeHandler(self)
    }
    
    override public func handleChallenge(challenge: [NSObject : AnyObject]!) {
        UserLoginChallengeHandler.loginDialog { (user, password, ok) -> Void in
            if (ok) {
                self.submitChallengeAnswer(["username": user, "password" : password])
            } else {
                self.cancel()
            }
        }
    }
    
    public static func loginDialog (completion: (user: String, password: String, ok: Bool) -> Void) {
        let loginDialog = UIAlertController(title: "Club Member Login", message: "Please provide club member credentials", preferredStyle: UIAlertControllerStyle.Alert)
        
        var userTxtField :UITextField?
        loginDialog.addTextFieldWithConfigurationHandler { (txtUser) -> Void in
            userTxtField = txtUser
            txtUser.placeholder = "<User Name>"
        }
        
        var passwordTxtField : UITextField?
        loginDialog.addTextFieldWithConfigurationHandler { (txtPassword) -> Void in
            passwordTxtField = txtPassword
            passwordTxtField?.secureTextEntry = true
            txtPassword.placeholder = "<Password>"
        }
        
        loginDialog.addAction(UIAlertAction(title: "Ok", style:.Default, handler: { (action: UIAlertAction!) in
            completion (user: userTxtField!.text!, password: passwordTxtField!.text!, ok: true)
        }))
        
        loginDialog.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            completion (user: "", password: "", ok: false)
        }))
        
        UIApplication.sharedApplication().delegate?.window!!.rootViewController!.presentViewController(loginDialog, animated: true, completion: nil)
    }
}