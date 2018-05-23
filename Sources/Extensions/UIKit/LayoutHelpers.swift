//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    /// Helper initializer to reduce the amount of values required to create a UIEdgeInsets, so you can do
    /// for example UIEdgeInsets(leading: 20).
    ///
    /// - Parameters:
    ///   - top:  Specify an amount to add a margin on the top anchor.
    ///   - leading: Specify an amount to add a margin on the leading anchor.
    ///   - bottom: Specify a negative amount to add a margin on the bottom anchor.
    ///   - trailing: Specify a negative amount to add a margin on the trailing anchor.
    public init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.init(top: top, left: leading, bottom: bottom, right: trailing)
    }

    public var leading: CGFloat {
        return left
    }

    public var trailing: CGFloat {
        return right
    }
}
