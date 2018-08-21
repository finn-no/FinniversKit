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

**FinniversKit** uses [Uber's snapshot test cases](https://github.com/uber/ios-snapshot-test-case) to compare the contents of a UIView against a reference image.

When you run the tests **FinniversKit** will take snapshot of all the components and will look for differences. If a difference is caught you'll be informed in the form of a failed test. Running the tests locally will generate a diff between the old and the new images so you can see what caused the test to fail.

### Testing a new component

To test a new component go to [DemoSnapshotTests.swift](Demo/DemoSnapshotTests.swift) and add a new `func` with the name of your component under the section that makes sense, for example if your component is a _Fullscreen_ component and it's called _RegisterView_ then you'll need to add a method to `FullscreenViewTests` your method should look like this:

```swift
func testRegisterView() {
    snapshot(.registerView)
}
```

Note that the `snapshot` method is a helper method that will call `FBSnapshotVerifyView` under the hood.

### Verifying changes for an existing component

If you make changes to any components you'll have to run the test for that component after changing `recordMode` to `true`. Doing this will generate a new reference image that will be used later to verify for changes that affect your component. After you've generated the reference image change `recordMode` back to `false`.

## License

**FinniversKit** is available under the Apache License 2.0. See the [LICENSE file](/LICENSE.md) for more info.

The **FINN.no** branding, icons, images, assets, sounds and others are solely reserved for usage within **FINN.no**, the main purpose of this library is for internal use and to be used as reference for other teams in how we do things inside **FINN.no**.
