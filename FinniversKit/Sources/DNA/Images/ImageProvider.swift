//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ImageProvider {
    
    // AnimatedRadioButtonView
    func brandRadioButtonSelected(index: Int) -> UIImage?
    func brandRadioButtonUnselected(index: Int) -> UIImage?
    
    // AnimatedCheckboxView
    func brandCheckboxSelected(index: Int) -> UIImage?
    func brandCheckboxUnselected(index: Int) -> UIImage?
    
    // FavoriteButton
    var brandFavouriteAdd: UIImage { get }
    var brandFavouriteAdded: UIImage { get }
    var brandCheckmark: UIImage { get }
    var brandSliderThumb: UIImage { get }
    var brandSliderThumbActive: UIImage { get }
}

// MARK: - Default FINN images

public struct DefaultImageProvider: ImageProvider {
    
    public static let shared = DefaultImageProvider()
    
    public func brandRadioButtonSelected(index: Int) -> UIImage? {
        UIImage.assetNamed("radiobutton-select-\(index)")
    }
    
    public func brandRadioButtonUnselected(index: Int) -> UIImage? {
        UIImage.assetNamed("radiobutton-unselected-\(index)")
    }
    
    public func brandCheckboxSelected(index: Int) -> UIImage? {
        UIImage.assetNamed("checkbox-selected-\(index)")
    }
    
    public func brandCheckboxUnselected(index: Int) -> UIImage? {
        UIImage.assetNamed("checkbox-unselected-\(index)")
    }
    
    public var brandFavouriteAdd: UIImage {
        UIImage(named: .favouriteAddImg)
    }
    
    public var brandFavouriteAdded: UIImage {
        UIImage(named: .favouriteAddedImg)
    }
    
    public var brandCheckmark: UIImage {
        UIImage(named: .checkmarkBlue)
    }
    
    public var brandSliderThumb: UIImage {
        UIImage(named: .sliderThumb)
    }
    
    public var brandSliderThumbActive: UIImage {
        UIImage(named: .sliderThumbActive)
    }
}
