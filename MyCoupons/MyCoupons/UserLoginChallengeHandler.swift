import IBMMobileFirstPlatformFoundation


public class UserLoginChallengeHandler : SecurityCheckChallengeHandler {
    public static let securityCheckName = "UserLogin"
    var userLoginViewController : UserLoginViewController?
    
    override init() {
        super.init(name: UserLoginChallengeHandler.securityCheckName)
        WLClient.sharedInstance().registerChallengeHandler(self)
    }
    
    override public func handleChallenge(challenge: [NSObject : AnyObject]!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.userLoginViewController = storyboard.instantiateViewControllerWithIdentifier("UserLoginViewController") as? UserLoginViewController
        UIApplication.sharedApplication().windows.first?.rootViewController?.presentViewController(self.userLoginViewController!, animated: true, completion: {
            
        })
    }
    
    public override func handleSuccess(success: [NSObject : AnyObject]!) {
        NSUserDefaults.standardUserDefaults().setObject(success["user"]!["displayName"]!!, forKey: "displayName")
        NSUserDefaults.standardUserDefaults().synchronize()
        UIApplication.sharedApplication().windows.first?.rootViewController?.dismissViewControllerAnimated(true, completion: {
            
        })
    }
}