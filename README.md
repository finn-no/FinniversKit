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

**FinniversKit** uses snapshot test cases to compare the contents of a UIView or CALayer against a reference image.

From within your test case, use `FBSnapshotVerifyView` to both generate reference images and compare. To generate the reference images, run the tests once with `self.recordMode = true`. The filename of the reference images will be the same as the test method name.

UIViews have to be given a frame, intrinsic content size and constraints does not work. UIViews within a UIViewController works as normal.

## License

**FinniversKit** is available under the Apache License 2.0. See the [LICENSE file](/LICENSE.md) for more info.

The **FINN.no** branding, icons, images, assets, sounds and others are solely reserved for usage within **FINN.no**, the main purpose of this library is for internal use and to be used as reference for other teams in how we do things inside **FINN.no**.
