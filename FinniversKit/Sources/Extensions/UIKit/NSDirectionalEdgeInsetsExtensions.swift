//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension NSDirectionalEdgeInsets {
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
}
