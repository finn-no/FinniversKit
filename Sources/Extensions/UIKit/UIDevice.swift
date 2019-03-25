//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit.UIDevice

// MARK: - UIDevice

extension UIDevice {

    internal class func isIPad() -> Bool {
        return current.userInterfaceIdiom == .pad
    }

    internal class func isIPhone() -> Bool {
        return current.userInterfaceIdiom == .phone
    }

    internal class func isSmallScreen() -> Bool {
        return isIPhone() && UIScreen.main.nativeBounds.height == 1136
    }

    internal class func isLandscape() -> Bool {
        return isIPad() && current.orientation.isLandscape
    }
}
