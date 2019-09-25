<p align="center"><img width=100% src="https://raw.githubusercontent.com/finn-no/FinniversKit/master/GitHub/cover-v5.jpg"></p>

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![](https://img.shields.io/badge/License-GPL%20v3-blue.svg)

**FinniversKit** holds all the UI elements of the FINN iOS app, the main reference for our components is our design system. This framework is composed of small components that are meant to be used as building blocks of the FINN iOS app.

In order to develop our components in an isolated way, we have structured them so they can be used independently of each other. Run the Demo project for a list of all our components.

<p align="center"><img width=100% src="https://raw.githubusercontent.com/finn-no/FinniversKit/master/GitHub/demo3.jpg"></p>

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

## Interesting things

### Folder structure (sources, resources, demo and tests)

- `Sources` folder contains Swift and Objective C files, grouped by relevant category/feature if needed
- `Resources` folder contains fonts, images, sounds, generated constants and other resources used in the framework
- `UnitTests` folder is used for snapshot tests and other files related to testing
- `Demo` folder is a place for files that belong to `Demo` target. It is good practise to have corresponding demo view for every component, fullscreen or recycling view.

### Delegates and data sources (instead blocks and injection)

In order to maintain consistency we have opted for using data sources for giving data to our recyclabe views and using delegates to interact for actions inside views.

If the view isn't recyclable then we use ViewModels. There are tradeoffs when you choose to be consistent instead of pragmatic but we hope that by having a clear pattern it reduces the discussion points and let's us focus on improving the UI and adding value to our users.

### Why not playgrounds?

Our Demo project has been setup in a way that every component is isolated, we initally started by using Xcode's playgrounds but we quickly outgrew it's capacitiy, reloading times weren't quicker than making the change and running the project again, also it wasn't possible to debug and set breakpoint on things and we couldn't use many of Xcode's useful utilities such as View herarchy inspector. Finally, the fact that we had to rebuild the project after making any change in the framework meant that we weren't as efficient as using plain Xcode projects (where rebuilding isn't necesary after making a change).

### Changelogs

This project has a `Gemfile` that specify some development dependencies, one of those is `pr_changelog` which is a tool that helps you to generate changelogs from the Git history of the repo. You install this by running `bundle install`.

To get the changes that have not been released yet just run:

```
$ pr_changelog
```

If you want to see what changes were released in the last version, run:

```
$ pr_changelog --last-release
```

You can always run the command with the `--help` flag when needed.

### Accessibility

Everything we do we aim it to be accessible, our two main areas of focus have been VoiceOver and Dynamic Type.

### Snapshot Testing

When making UI changes it's quite common that we would request an screenshot of the before and after, adding Snapshot testing made this trivial, if there was UI changes you would get a failure when building through the CI.

**FinniversKit** uses TODO to compare the contents of a UIView against a reference image.

When you run the tests **FinniversKit** will take snapshot of all the components and will look for differences. If a difference is caught you'll be informed in the form of a failed test. Running the tests locally will generate a diff between the old and the new images so you can see what caused the test to fail.

#### Testing a new component

To test a new component go to [UnitTests](UnitTests) and add a new `func` with the name of your component under the section that makes sense, for example if your component is a _Fullscreen_ component and it's called _RegisterView_ then you'll need to add a method to [FullscreenViewTests.swift](UnitTests/FullscreenViewTests.swift) your method should look like this:

```swift
func testRegisterView() {
    snapshot(.registerView)
}
```

Note that the `snapshot` method is a helper method that will call `FBSnapshotVerifyView` under the hood.

#### Verifying changes for an existing component

If you make changes to any components you'll have to run the test for that component after changing `recordMode` to `true`. Doing this will generate a new reference image that will be used later to verify for changes that affect your component. After you've generated the reference image change `recordMode` back to `false`.

## License

**FinniversKit** is available under the GNU General Public License v3.0. See the [LICENSE file](/LICENSE.md) for more info.

The **FINN.no** branding, icons, images, assets, sounds and others are solely reserved for usage within **FINN.no**, the main purpose of this library is for internal use and to be used as reference for other teams in how we do things inside **FINN.no**.
