# Troika framework for iOS
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![](https://img.shields.io/badge/platform-iOS-lightgrey.svg) ![](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)

# Table of content
1. [Introduction](#introduction)
2. [Structure](#structure)
    1. [Protocols](#protocols)
    2. [Extensions](#extensions)
    3. [Templates](#templates)
    4. [Resources](#resources)
3. [Components](#components)
   1. [Toast](#toast)
   2. [Label](#label)
   3. [Ribbon](#ribbon)
   4. [MarketGrid](#market_grid)
   5. [Preview Grid](#preview_grid)
4. [Installation](#installation)
5. [Usage](#usage)

## Introduction <a name="introduction"></a>
Some introduction text.

## Structure <a name="structure"></a>
Explaning the structure/architecture of the project.

### Protocols <a name="protocols"></a>
What goes in the ´Protocols´ folder?

### Extensions <a name="extensions"></a>
What goes in the ´Extensions´ folder?

### Templates <a name="templates"></a>
The template is a guideline of the structure of the classes, written in Swift...

### Resources <a name="resources"></a>
Fonts and image assets.

## Components <a name="components"></a>
Explain the different components

### Toast <a name="toast"></a>
Toast

### Label <a name="label"></a>
Label

### Ribbon <a name="ribbon"></a>
Ribbon

### MarketGrid <a name="market_grid"></a>
Market
#### MarketGrid View
The view
#### MarketGrid Cell
The cell

### Preview Grid <a name="preview_grid"></a>
Preview
#### PreviewGridView
The view
#### Preview Grid Cell
The cell

## Installation <a name="installation"></a>
### Carthage
```
github "finn-no/troika-ios" ~> 0.2
```
## Usage <a name="usage"></a>
Remember to use the following command so that the custom FINN fonts are loaded from the framework bundle:
``` Swift
UIFont.registerTroikaFonts()
```
