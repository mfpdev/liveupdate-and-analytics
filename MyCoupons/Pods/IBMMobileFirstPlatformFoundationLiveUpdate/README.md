MobileFirst Foundation - LiveUpdate iOS SDK
===

[![Build Status](https://travis-ci.org/mfpdev/mfp-live-update-ios-sdk.svg?branch=master)](https://travis-ci.org/mfpdev/mfp-live-update-ios-sdk)

###Contents
LiveUpdate iOS SDK lets you query runtime configuration properties and features which you set in the LiveUpdate Settings screen in the MobileFirst Operations Console.
With LiveUpdate integrated in your application you can implement feature toggling, A/B testing, feature segmentation and more. 

###Installation

#### Install Using CocaPods
```cocapods
use_frameworks!

target 'TestLiveUpdate' do
    pod 'IBMMobileFirstPlatformFoundationLiveUpdate'
end
```

### Configuration In MobileFirst Operation Console
In your application under Scope-Elements Mapping in security tab you must map the scope 'configuration-user-login' to security check, you can map it to empty string if you want to use the default protection.  More info about [scope mapping](https://mobilefirstplatform.ibmcloud.com/tutorials/en/foundation/8.0/authentication-and-security/authorization-concepts/#scope-mapping)

#### Sample Usages Of The API

##### Obtain Configuration By Segment :

```Swift
LiveUpdateManager.sharedInstance.obtainConfiguration("segment1", completionHandler: { (configuration, error) in
  if error == nil {
    print (configuration?.getProperty("property1"))
    print (configuration?.isFeatureEnabled("feature1"))
  } else {
    print (error)
  }
})
```

##### Obtain Configuration By Params :

```Swift
LiveUpdateManager.sharedInstance.obtainConfiguration(["paramKey":"paramValue"], completionHandler: { (configuration, error) in
  if error == nil {
    print (configuration?.getProperty("property1"))
    print (configuration?.isFeatureEnabled("feature1"))
  } else {
    print (error)
  }
})
```


##### Disable cache (by default the cache is enabled):

```Swift
LiveUpdateManager.sharedInstance.obtainConfiguration("segment1", useCache: false, completionHandler: { (configuration, error) in
  if error == nil {
    print (configuration?.getProperty("property1"))
    print (configuration?.isFeatureEnabled("feature1"))
  } else {
    print (error)
  }
})
```

###Supported Levels
- iOS 8
- iOS 9


Copyright 2015 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
