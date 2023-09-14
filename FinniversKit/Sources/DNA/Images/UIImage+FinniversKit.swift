//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@objc public extension UIImage {

    class func brandRadioButtonSelected(index: Int) -> UIImage? {
        Config.imageProvider.brandRadioButtonSelected(index: index)
    }
    
    class func brandRadioButtonUnselected(index: Int) -> UIImage? {
        Config.imageProvider.brandRadioButtonUnselected(index: index)
    }
    
    class func brandCheckboxSelected(index: Int) -> UIImage? {
        Config.imageProvider.brandCheckboxSelected(index: index)
    }
    
    class func brandCheckboxUnselected(index: Int) -> UIImage? {
        Config.imageProvider.brandCheckboxUnselected(index: index)
    }
    
    class var brandFavouriteAdd: UIImage {
        Config.imageProvider.brandFavouriteAdd
    }
    
    class var brandFavouriteAdded: UIImage {
        Config.imageProvider.brandFavouriteAdded
    }
    
    class var brandCheckmark: UIImage {
        Config.imageProvider.brandCheckmark
    }
    
    class var brandSliderThumb: UIImage {
        Config.imageProvider.brandSliderThumb
    }
    
    class var brandSliderThumbActive: UIImage {
        Config.imageProvider.brandSliderThumbActive
    }
}
