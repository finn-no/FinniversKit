import UIKit

extension UIView {
    convenience init(withAutoLayout autoLayout: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = !autoLayout
    }

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
        constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left))
        constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom))
        constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right))

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    func fillInSuperview(margin: CGFloat, isActive: Bool = true) -> [NSLayoutConstraint] {
        let insets = UIEdgeInsets(top: margin, left: margin, bottom: -margin, right: -margin)
        return fillInSuperview(insets: insets, isActive: isActive)
    }

    @discardableResult
    func fillInSuperviewLayoutMargins() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return []
        }

        let constraints: [NSLayoutConstraint] = [
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.layoutMarginsGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.layoutMarginsGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)

        return constraints
    }

    @discardableResult
    func fillInSuperviewReadableArea() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return []
        }

        let constraints: [NSLayoutConstraint] = [
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.readableContentGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.readableContentGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)

        return constraints
    }

    @discardableResult
    func fillInSuperviewSafeArea() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return []
        }

        let constraints: [NSLayoutConstraint] = [
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)

        return constraints
    }

    @discardableResult
    func centerInSuperview() -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return []
        }

        let constraints: [NSLayoutConstraint] = [
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
        ]

        NSLayoutConstraint.activate(constraints)

        return constraints
    }

    @discardableResult
    func centerAndConstraintInSuperview(margin: CGFloat = 0) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            return []
        }

        centerInSuperview()

        let constraints: [NSLayoutConstraint] = [
            heightAnchor.constraint(lessThanOrEqualTo: superview.heightAnchor, constant: -margin * 2),
            widthAnchor.constraint(lessThanOrEqualTo: superview.widthAnchor, constant: -margin * 2),
        ]

        NSLayoutConstraint.activate(constraints)

        return constraints
    }
}

extension UIStackView {
    convenience init(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat? = nil,
        alignment: UIStackView.Alignment? = nil,
        distribution: UIStackView.Distribution? = nil,
        withAutoLayout: Bool = false
    ) {
        self.init(withAutoLayout: withAutoLayout)
        self.axis = axis

        if let spacing = spacing {
            self.spacing = spacing
        }

        if let alignment = alignment {
            self.alignment = alignment
        }

        if let distribution = distribution {
            self.distribution = distribution
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
