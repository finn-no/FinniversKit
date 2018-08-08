<p align="center"><img width=100% src="https://raw.githubusercontent.com/finn-no/FinniversKit/master/GitHub/cover-v5.jpg"></p>

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)

FinniversKit is the iOS native implementation of FINN's design system. [You can find the reference here](https://finnivers.finn.no/d/oCLrx0cypXJM/design-system). This framework is composed of small components that are meant to be used as building blocks of the FINN iOS app.

In order to develop our components in an isolated way, we have structured them so they can be used independently of each other. Run the Demo project for a list of all our components.

<p align="center"><img width=100% src="https://raw.githubusercontent.com/finn-no/FinniversKit/master/GitHub/demo2.jpg"></p>

## Installation

### Carthage

```
github "finn-no/FinniversKit" "master"
```

## Usage

Import the framework to access all the components.

```swift
import FinniversKit
```

## Snapshot Testing

**FinniversKit** uses [Uber's snapshot test cases](https://github.com/uber/ios-snapshot-test-case) to compare the contents of a UIView or UIViewController against a reference image.

From within your test case, use `FBSnapshotVerifyView` to both generate reference images and compare them against your current view. To generate the reference images, run the tests once with `self.recordMode = true`, once the reference images have been created you can set `self.recordMode = false` to test your views for any changes.

The filename of the reference images will be the same as the test method name. `isDeviceAgnostic = true` will append the device model, iOS version and screen size to the file name. This way, you will have separate reference images for iPad and iPhone, as well as iPhone X and iPhone 8, etc.

UIViews have to be given a frame, intrinsic content size and constraints does not work. UIViews within a UIViewController works as normal.

### Example

```swift
//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class YourComponentDemoViewTest: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
        isDeviceAgnostic = false
    }

    func testExampleControllerView() {
        let controller = ViewController<YourComponentViewController>()
        FBSnapshotVerifyView(controller.view)
    }
}
```

## License

**FinniversKit** is available under the Apache License 2.0. See the [LICENSE file](/LICENSE.md) for more info.

The **FINN.no** branding, icons, images, assets, sounds and others are solely reserved for usage within **FINN.no**, the main purpose of this library is for internal use and to be used as reference for other teams in how we do things inside **FINN.no**.
