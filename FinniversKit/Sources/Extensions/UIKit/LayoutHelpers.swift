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

    /// Helper to quickly initialize the values for all sides with the same value
    ///
    /// - Parameter all: Specify an amount for all insets.
    public init(all: CGFloat) {
        self.init(top: all, leading: all, bottom: all, trailing: all)
    }

    /// Helper to quickly initialize the values for vertical and horizontal insets
    ///
    /// - Parameters:
    ///   - vertical: Specify the amount for the top and bottom margins.
    ///   - horizontal: Specify the amount for the left and right margins.
    public init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }

    public var leading: CGFloat {
        return left
    }

    public var trailing: CGFloat {
        return right
    }
}
