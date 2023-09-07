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
        UIImage(named: "radiobutton-select-\(index)", in: .finniversKit, compatibleWith: nil)
    }
    
    public func brandRadioButtonUnselected(index: Int) -> UIImage? {
        UIImage(named: "radiobutton-unselected-\(index)", in: .finniversKit, compatibleWith: nil)
    }
    
    public func brandCheckboxSelected(index: Int) -> UIImage? {
        UIImage(named: "checkbox-selected-\(index)", in: .finniversKit, compatibleWith: nil)
    }
    
    public func brandCheckboxUnselected(index: Int) -> UIImage? {
        UIImage(named: "checkbox-unselected-\(index)", in: .finniversKit, compatibleWith: nil)
    }
    
    public var brandFavouriteAddImg: UIImage {
        UIImage(named: .favouriteAddImg)
    }
    
    public var brandFavouriteAddedImg: UIImage {
        UIImage(named: .favouriteAddedImg)
    }
}
