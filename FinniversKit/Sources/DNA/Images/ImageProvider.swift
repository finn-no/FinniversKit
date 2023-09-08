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
    var brandFavouriteAddImg: UIImage { get }
    var brandFavouriteAddedImg: UIImage { get }
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
    
    public var brandFavouriteAddImg: UIImage {
        UIImage(named: .favouriteAddImg)
    }
    
    public var brandFavouriteAddedImg: UIImage {
        UIImage(named: .favouriteAddedImg)
    }
}
