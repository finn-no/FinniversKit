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
    
    // Images for AnimatedCheckboxView
    class func brandCheckboxSelected(index: Int) -> UIImage? {
        Config.imageProvider.brandCheckboxSelected(index: index)
    }
    
    class func brandCheckboxUnselected(index: Int) -> UIImage? {
        Config.imageProvider.brandCheckboxUnselected(index: index)
    }
    
    class var brandFavouriteAddImg: UIImage {
        Config.imageProvider.brandFavouriteAddImg
    }
    
    class var brandFavouriteAddedImg: UIImage {
        Config.imageProvider.brandFavouriteAddedImg
    }
}
