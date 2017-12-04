//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

// Heavily inspired in TinyConstraints by Robert Hein.
// https://github.com/roberthein/TinyConstraints

import UIKit

public extension Constrainable {

    @discardableResult
    public func center(in view: Constrainable, offset: CGPoint = .zero, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        let constraints = [
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.x).with(priority),
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.y).with(priority),
        ]

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func fill(in view: Constrainable, insets: UIEdgeInsets = .zero, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        let constraints = [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).with(priority),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).with(priority),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).with(priority),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).with(priority),
        ]

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func size(_ size: CGSize, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        let constraints = [
            widthAnchor.constraint(equalToConstant: size.width).with(priority),
            heightAnchor.constraint(equalToConstant: size.height).with(priority),
        ]

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func size(to view: Constrainable, multiplier: CGFloat = 1, offset: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        let constraints = [
            widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier, constant: offset).with(priority),
            heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier, constant: offset).with(priority),
        ]

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func origin(to view: Constrainable, insets: CGVector = .zero, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        let constraints = [
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.dx).with(priority),
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.dy).with(priority),
        ]

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    @discardableResult
    public func width(_ width: CGFloat, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return widthAnchor.constraint(equalToConstant: width).with(priority).set(active: isActive)
        case .equalOrLess: return widthAnchor.constraint(lessThanOrEqualToConstant: width).with(priority).set(active: isActive)
        case .equalOrGreater: return widthAnchor.constraint(greaterThanOrEqualToConstant: width).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func width(to view: Constrainable, _ dimension: NSLayoutDimension? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return widthAnchor.constraint(equalTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return widthAnchor.constraint(lessThanOrEqualTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return widthAnchor.constraint(greaterThanOrEqualTo: dimension ?? view.widthAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func width(min: CGFloat? = nil, max: CGFloat? = nil, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        if let min = min {
            let constraint = widthAnchor.constraint(greaterThanOrEqualToConstant: min).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }

        if let max = max {
            let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: max).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }

        return constraints
    }

    @discardableResult
    public func height(_ height: CGFloat, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return heightAnchor.constraint(equalToConstant: height).with(priority).set(active: isActive)
        case .equalOrLess: return heightAnchor.constraint(lessThanOrEqualToConstant: height).with(priority).set(active: isActive)
        case .equalOrGreater: return heightAnchor.constraint(greaterThanOrEqualToConstant: height).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func height(to view: Constrainable, _ dimension: NSLayoutDimension? = nil, multiplier: CGFloat = 1, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return heightAnchor.constraint(equalTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return heightAnchor.constraint(lessThanOrEqualTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return heightAnchor.constraint(greaterThanOrEqualTo: dimension ?? view.heightAnchor, multiplier: multiplier, constant: offset).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func height(min: CGFloat? = nil, max: CGFloat? = nil, priority: UILayoutPriority = .required, isActive: Bool = true) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        if let min = min {
            let constraint = heightAnchor.constraint(greaterThanOrEqualToConstant: min).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }

        if let max = max {
            let constraint = heightAnchor.constraint(lessThanOrEqualToConstant: max).with(priority)
            constraint.isActive = isActive
            constraints.append(constraint)
        }

        return constraints
    }

    @discardableResult
    public func leadingToTrailing(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return leading(to: view, view.trailingAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func leading(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return leadingAnchor.constraint(equalTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return leadingAnchor.constraint(lessThanOrEqualTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return leadingAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.leadingAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func leftToRight(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return left(to: view, view.rightAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func left(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return leftAnchor.constraint(equalTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return leftAnchor.constraint(lessThanOrEqualTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return leftAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.leftAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func trailingToLeading(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return trailing(to: view, view.leadingAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func trailing(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return trailingAnchor.constraint(equalTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return trailingAnchor.constraint(lessThanOrEqualTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return trailingAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.trailingAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func rightToLeft(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return right(to: view, view.leftAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func right(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return rightAnchor.constraint(equalTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return rightAnchor.constraint(lessThanOrEqualTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return rightAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.rightAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func topToBottom(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return top(to: view, view.bottomAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func top(to view: Constrainable, _ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return topAnchor.constraint(equalTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return topAnchor.constraint(lessThanOrEqualTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return topAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.topAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func bottomToTop(of view: Constrainable, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        return bottom(to: view, view.topAnchor, offset: offset, relation: relation, priority: priority, isActive: isActive)
    }

    @discardableResult
    public func bottom(to view: Constrainable, _ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, relation: ConstraintRelation = .equal, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        switch relation {
        case .equal: return bottomAnchor.constraint(equalTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrLess: return bottomAnchor.constraint(lessThanOrEqualTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(active: isActive)
        case .equalOrGreater: return bottomAnchor.constraint(greaterThanOrEqualTo: anchor ?? view.bottomAnchor, constant: offset).with(priority).set(active: isActive)
        }
    }

    @discardableResult
    public func centerX(to view: Constrainable, _ anchor: NSLayoutXAxisAnchor? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = centerXAnchor.constraint(equalTo: anchor ?? view.centerXAnchor, constant: offset).with(priority)
        constraint.isActive = isActive
        return constraint
    }

    @discardableResult
    public func centerY(to view: Constrainable, _ anchor: NSLayoutYAxisAnchor? = nil, offset: CGFloat = 0, priority: UILayoutPriority = .required, isActive: Bool = true) -> NSLayoutConstraint {
        let constraint = centerYAnchor.constraint(equalTo: anchor ?? view.centerYAnchor, constant: offset).with(priority)
        constraint.isActive = isActive
        return constraint
    }
}
