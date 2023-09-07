//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ImageProvider {
    
    // AnimatedRadioButtonView
    func radioButtonSelected(index: Int) -> UIImage?
    func radioButtonUnselected(index: Int) -> UIImage?
    
    // AnimatedCheckboxView
    func checkboxSelected(index: Int) -> UIImage?
    func checkboxUnselected(index: Int) -> UIImage?
    
    // FavoriteButton
    var favouriteAddImg: UIImage { get }
    var favouriteAddedImg: UIImage { get }
}

// MARK: - Default FINN images

public struct DefaultImageProvider: ImageProvider {
    
    public static let shared = ImageProvider()
    
    public func radioButtonSelected(index: Int) -> UIImage? {
        UIImage(named: "radiobutton-select-\(index)", in: .finniversKit, compatibleWith: nil)
    }
    
    public func radioButtonUnselected(index: Int) -> UIImage? {
        UIImage(named: "radiobutton-unselected-\(index)", in: .finniversKit, compatibleWith: nil)
    }
    
    public func checkboxSelected(index: Int) -> UIImage? {
        UIImage(named: "checkbox-selected-\(index)", in: .finniversKit, compatibleWith: nil)
    }
    
    public func checkboxUnselected(index: Int) -> UIImage? {
        UIImage(named: "checkbox-unselected-\(index)", in: .finniversKit, compatibleWith: nil)
    }
    
    public var favouriteAddImg: UIImage {
        UIImage(named: .favouriteAddImg)
    }
    
    public var favouriteAddedImg: UIImage {
        UIImage(named: .favouriteAddedImg)
    }
}
