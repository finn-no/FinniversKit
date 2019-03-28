//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit.UIDevice

// MARK: - UIDevice

extension UIDevice {

    class func isIPad() -> Bool {
        return current.userInterfaceIdiom == .pad
    }

    class func isIPhone() -> Bool {
        return current.userInterfaceIdiom == .phone
    }
}
