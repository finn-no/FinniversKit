//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@objc public extension UIImage {

    class func radioButtonSelected(index: Int) -> UIImage? {
        Config.imageProvider.radioButtonSelected(index: index)
    }
    
    class func radioButtonUnselected(index: Int) -> UIImage? {
        Config.imageProvider.radioButtonUnselected(index: index)
    }
    
    // Images for AnimatedCheckboxView
    class func checkboxSelected(index: Int) -> UIImage? {
        Config.imageProvider.checkboxSelected(index: index)
    }
    
    class func checkboxUnselected(index: Int) -> UIImage? {
        Config.imageProvider.checkboxUnselected(index: index)
    }
    
    class var favouriteAddImg: UIImage {
        Config.imageProvider.favouriteAddImg
    }
    
    class var favouriteAddedImg: UIImage {
        Config.imageProvider.favouriteAddedImg
    }
}
