import UIKit

public extension UIView {
    /// Layouts the current view to fit it's superview.
    ///
    /// - Parameters:
    ///   - insets: The inset for fitting the superview.
    ///   - isActive: A boolean on whether the constraint is active or not.
    /// - Returns: The added constraints.
    @discardableResult
    func fillInSuperview(insets: UIEdgeInsets = .zero, isActive: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            return [NSLayoutConstraint]()
        }

        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()
        constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top))
        constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.leading))
        constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom))
        constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.trailing))

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    func fillInSuperview(margin: CGFloat, isActive: Bool = true) -> [NSLayoutConstraint] {
        let insets = UIEdgeInsets(top: margin, leading: margin, bottom: -margin, trailing: -margin)
        return fillInSuperview(insets: insets, isActive: isActive)
    }

    @discardableResult
    func fillInSuperviewLayoutMargins() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return []
        }

        let constrains: [NSLayoutConstraint] = [
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constrains)

        return constrains
    }
}
