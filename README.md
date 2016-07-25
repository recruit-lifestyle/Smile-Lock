# SmileLock

[![GitHub Issues](http://img.shields.io/github/issues/recruit-lifestyle/Smile-Lock.svg?style=flat)](https://github.com/recruit-lifestyle/Smile-Lock/issues)
[![Version](https://img.shields.io/cocoapods/v/SmileLock.svg?style=flat)](http://cocoadocs.org/docsets/SmileLock)
[![License](https://img.shields.io/cocoapods/l/SmileLock.svg?style=flat)](http://cocoadocs.org/docsets/SmileLock)
[![Platform](https://img.shields.io/cocoapods/p/SmileLock.svg?style=flat)](http://cocoadocs.org/docsets/SmileLock)

A library for make a beautiful Passcode Lock View.

<img src="SmileLock-Example/demo_gif/smilelock_logo.png" width="600">

<img src="SmileLock-Example/demo_gif/demo.gif" width="400">
<img src="SmileLock-Example/demo_gif/demo_blur.gif" width="400">

#What can it do for you?


#### 1. Create a beautiful passcode lock view simply.

``` swift
let kPasswordDigit = 6
self.passwordContainerView = PasswordContainerView.createWithDigit(kPasswordDigit)
```

#### 2. Passcode input completed delegate callback.

``` swift
let passwordContainerView: PasswordContainerView = ...
passwordContainerView.delegate = self

extension ViewController: PasswordInputCompleteProtocol {
    func passwordInputComplete(passwordContainerView: PasswordContainerView, input: String) {
        print("input completed -> \(input)")
        //handle validation wrong || success
    }
}

```

#### 3. Touch ID.

Thanks for the contribution of [Piotr Sochalewski](https://github.com/sochalewski).👍

``` swift
extension ViewController: PasswordInputCompleteProtocol {
     func touchAuthenticationComplete(passwordContainerView: PasswordContainerView, success: Bool) {
        if success {
            //authentication success
        } else {
            passwordContainerView.clearInput()
        }
    }
}
```

#### 4. Customize UI.

``` swift
self.passwordContainerView.tintColor = UIColor.color(.TextColor)
self.passwordContainerView.highlightedColor = UIColor.color(.Blue)
```

#### 5. Visual Effect.
If you want to see visual effect verison (blur view and vibrancy view), choose `BlurPasswordLogin.storyboard` as main storyboard.

<img src="SmileLock-Example/demo_gif/blur_version.png"">


#How to use it for your project?

SmileLock is available through use [CocoaPods](http://cocoapods.org).

To install it, simply add the following line to your Podfile:

```Ruby
pod 'SmileLock'
```
Or you can drag the [SmileLock](https://github.com/recruit-lifestyle/Smile-Lock/tree/master/SmileLock) folder to your project.

# Contributions

* Warmly welcome to submit a pull request.

## Credits
SmileLock is owned and maintained by [RECRUIT LIFESTYLE CO., LTD.](http://www.recruit-lifestyle.co.jp/).

# License
```
Copyright (c) 2016 RECRUIT LIFESTYLE CO., LTD.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
