//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

extension NSLayoutAnchor {
    /// Convenience method to create constraints and set the priority to them
    ///
    /// - Parameters:
    ///   - anchor: anchor to constraint the current anchor to
    ///   - constant: space between anchors
    ///   - priority: layout priority for the constraint
    /// - Returns: a constraint to the given anchor from `self` with the right constant and priority
    @objc public func constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let newConstraint = self.constraint(equalTo: anchor, constant: constant)
        newConstraint.priority = priority

        return newConstraint
    }
}
