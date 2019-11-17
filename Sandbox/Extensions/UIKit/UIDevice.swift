//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit.UIDevice

// MARK: - UIDevice

extension UIDevice {

    public class func isIPad() -> Bool {
        return current.userInterfaceIdiom == .pad
    }

    public class func isIPhone() -> Bool {
        return current.userInterfaceIdiom == .phone
    }
}
