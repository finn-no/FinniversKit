# Troika framework for iOS
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) ![](https://img.shields.io/badge/platform-iOS-lightgrey.svg)

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
   4. [Market Grid](#market_grid)
       1. [Market Grid View](#market_grid_view)
       2. [Market Grid Cell](#market_grid_cell)
   5. [Preview Grid](#preview_grid)
       1. [Preview Grid View](#preview_grid_view)
       2. [Previwe Grid Cell](#preview_grid_cell)
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

### Market Grid <a name="market_grid"></a>
Market
#### Market Grid View <a name="market_grid_view"></a>
The view
#### Market Grid Cell <a name="market_grid_cell"></a>
The cell

### Preview Grid <a name="preview_grid"></a>
Preview
#### Preview Grid View <a name="preview_grid_view"></a>
The view
#### Preview Grid Cell <a name="preview_grid_cell"></a>
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
