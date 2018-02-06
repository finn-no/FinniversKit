<p align="center"><img width=100% src="https://raw.githubusercontent.com/finn-no/Finnivers/master/GitHub/cover-v3.png"></p>

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)

Finnivers is the iOS native implementation of FINN's design system. [You can find the reference here](http://finnivers.finn.no/d/2koIuZwTP5cy/design-system). This framework is composed of small components that are meant to be used as building blocks of the FINN iOS app. 

In order to develop our components in an isolated way we have structured them so they can be used idependently of each other. Run the Demo project for a list of all our components.

<p align="center"><img width=100% src="https://raw.githubusercontent.com/finn-no/Finnivers/master/GitHub/demo.png"></p>

## Installation

### Carthage

```
github "finn-no/Finnivers" "master"
```

## Usage

Import the framework to access all the components.

```swift
import Finnivers
```

In your AppDelegate call the following line to register the custom fonts in your project.

``` Swift
UIFont.registerFinniversFonts()
```

## License

**Finnivers** is available under the Apache License 2.0. See the [LICENSE file](/LICENSE.md) for more info.

The **FINN.no** branding, icons, images, assets, sounds and others are solely reserved for usage within **FINN.no**, the main purpose of this library is for internal use and to be used as reference for other teams in how we do things inside **FINN.no**.
