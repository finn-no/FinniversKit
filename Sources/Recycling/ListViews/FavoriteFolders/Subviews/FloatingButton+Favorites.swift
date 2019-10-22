//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension FloatingButton {
    static func favoritesXmasButton(withTarget target: Any? = nil, action: Selector? = nil) -> FloatingButton {
        let button = FloatingButton(withAutoLayout: true)
        button.primaryBackgroundColor = .cherry
        button.highlightedBackgroundColor = UIColor.cherry.withAlphaComponent(0.8)
        button.tintColor = .milk
        button.layer.borderWidth = .smallSpacing
        button.layer.borderColor = .milk
        button.setImage(UIImage(named: .favoritesXmasButton).withRenderingMode(.alwaysTemplate), for: .normal)

        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        return button
    }
}
