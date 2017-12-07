//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/// A struct that holds the insets when laying out a view.
public struct EdgeInsets {
    // Replace with NSDirectionalEdgeInsets when going for > iOS 11.
    // The reason for using this instead of UIEdgeInsets is because in UIEdgeInsets uses left and right instead of
    // leading and trailing.

    let top: CGFloat
    let leading: CGFloat
    let bottom: CGFloat
    let trailing: CGFloat

    public static var zero: EdgeInsets {
        return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}

public extension UIView {

    /// Layouts the current view to fit it's superview.
    ///
    /// - Parameters:
    ///   - insets: The inset for fitting the superview.
    ///   - isActive: A boolean on whether the constraint is active or not.
    /// - Returns: The added constraints.
    @discardableResult
    func fillInSuperview(insets: EdgeInsets = .zero, isActive: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            return [NSLayoutConstraint]()
        }

        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()
        constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top))
        constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.leading))
        constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom))
        constraints.append(trailingAnchor.constraint(equalTo: superview.rightAnchor, constant: insets.trailing))

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }
}
