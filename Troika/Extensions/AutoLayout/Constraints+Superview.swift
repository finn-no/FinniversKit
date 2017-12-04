//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

// Heavily inspired in TinyConstraints by Robert Hein.
// https://github.com/roberthein/TinyConstraints

import UIKit

public extension UIView {

    @discardableResult
    func fillInSuperview(insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        constraints.append(topToSuperview(offset: insets.top))
        constraints.append(leftToSuperview(offset: insets.left))
        constraints.append(rightToSuperview(offset: -insets.right))
        constraints.append(bottomToSuperview(offset: -insets.bottom))

        return constraints
    }

    @discardableResult
    public func leadingToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)

        return leading(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    public func trailingToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)

        return trailing(to: constrainable, anchor, offset: -offset, relation: relation, priority: priority, isActive: isActive)
    }
}

public extension UIView {

    private func safeConstrainable(for superview: UIView?, usingSafeArea: Bool) -> Constrainable {
        guard let superview = superview else { fatalError("Unable to create this constraint to it's superview, because it has no superview.") }
        prepareForLayout()

        if #available(iOS 11, tvOS 11, *) {
            if usingSafeArea {
                return superview.safeAreaLayoutGuide
            }
        }

        return superview
    }

    @discardableResult
    public func centerInSuperview(offset: CGPoint = .zero, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return center(in: constrainable, offset: offset, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func fillInSuperview(insets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return fill(in: constrainable, insets: insets, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func originToSuperview(insets: CGVector = .zero, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> [NSLayoutConstraint] {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return origin(to: constrainable, insets: insets, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func leftToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return left(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func rightToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return right(to: constrainable, anchor, offset: -offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func topToSuperview(_ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return top(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func bottomToSuperview(_ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return bottom(to: constrainable, anchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func centerXToSuperview(_ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return centerX(to: constrainable, anchor, offset: offset, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func centerYToSuperview(_ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true, usingSafeArea: Bool = false) -> NSLayoutConstraint {
        let constrainable = safeConstrainable(for: superview, usingSafeArea: usingSafeArea)
        return centerY(to: constrainable, anchor, offset: offset, priority: priority, isActive: isActive)
    }
}
