//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat? = nil, withAutoLayout: Bool = false) {
        self.init(withAutoLayout: withAutoLayout)
        self.axis = axis

        if let spacing = spacing {
            self.spacing = spacing
        }
    }

    func removeArrangedSubviews() {
        for oldSubview in arrangedSubviews {
            removeArrangedSubview(oldSubview)
            oldSubview.removeFromSuperview()
        }
    }

    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach(addArrangedSubview)
    }
}
