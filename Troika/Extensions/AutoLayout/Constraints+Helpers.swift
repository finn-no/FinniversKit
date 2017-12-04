//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

// Heavily inspired in TinyConstraints by Robert Hein.
// https://github.com/roberthein/TinyConstraints

import UIKit

extension UIView: Constrainable {

    @discardableResult
    public func prepareForLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}

extension UILayoutGuide: Constrainable {
    @discardableResult
    public func prepareForLayout() -> Self { return self }
}

public protocol Constrainable {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }

    @discardableResult
    func prepareForLayout() -> Self
}

public enum ConstraintRelation: Int {
    case equal = 0
    case equalOrLess = -1
    case equalOrGreater = 1
}

public extension Collection where Iterator.Element == NSLayoutConstraint {

    func activate() {

        if let constraints = self as? [NSLayoutConstraint] {
            NSLayoutConstraint.activate(constraints)
        }
    }

    func deActivate() {

        if let constraints = self as? [NSLayoutConstraint] {
            NSLayoutConstraint.deactivate(constraints)
        }
    }
}

public extension NSLayoutConstraint {
    @objc
    func with(_ p: UILayoutPriority) -> Self {
        priority = p
        return self
    }

    func set(active: Bool) -> Self {
        isActive = active
        return self
    }
}

public extension UIView {

    public func setHugging(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        setContentHuggingPriority(priority, for: axis)
    }

    public func setCompressionResistance(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        setContentCompressionResistancePriority(priority, for: axis)
    }
}
