# Troika framework for iOS
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)

## Table of contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Introduction

Troika is the iOS native implementation of FINN's design system. [You can find the reference here](http://finnivers.finn.no/d/2koIuZwTP5cy/design-system). This framework is composed of small components that are meant to be used as building blocks of the FINN iOS app. 

In order to develop our components in an isolated way we have structured them so they can be used idependently of each other. Check the [App.swift](/Playground/App.swift) for a list of all our components, to try a different component change the `typealias View` to a different Playground and run the project.

## Installation

### Carthage

```
github "finn-no/troika-ios" "master"
```

## Usage

Import the framework to access all the components.

```swift
import Troika
```

In your AppDelegate call the following line to register the custom fonts in your project.

``` Swift
UIFont.registerTroikaFonts()
```

## License

**Troika** is available under the Apache License 2.0. See the [LICENSE file](/LICENSE.md) for more info.

The **FINN.no** branding, icons, images, assets, sounds and others are solely reserved for usage within **FINN.no.**
