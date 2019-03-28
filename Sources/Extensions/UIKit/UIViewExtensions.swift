//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension UIView {
    public convenience init(withAutoLayout autoLayout: Bool) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = !autoLayout
    }

    public var compatibleTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }

    public var compatibleBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }

    public var safeLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide
        } else {
            return layoutMarginsGuide
        }
    }

    public func dropShadow(color: UIColor, opacity: Float = 0.5, offset: CGSize = CGSize.zero, radius: CGFloat = 10.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.rasterizationScale = UIScreen.main.scale
    }
}
