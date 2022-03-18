//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension FloatingButton {
    static func favoritesXmasButton(withTarget target: Any? = nil, action: Selector? = nil) -> FloatingButton {
        let button = FloatingButton(withAutoLayout: true, style: .favoritesXmasButtonStyle)
        button.setImage(UIImage(named: .favoritesXmasButton).withRenderingMode(.alwaysTemplate), for: .normal)

        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        return button
    }
}

public extension FloatingButton.Style {
    static var favoritesXmasButtonStyle: FloatingButton.Style {
        FloatingButton.Style(
            tintColor: .milk,
            titleColor: .textTertiary,
            primaryBackgroundColor: .cherry,
            highlightedBackgroundColor: .cherry.withAlphaComponent(0.8),
            borderWidth: .spacingXS,
            borderColor: .milk,
            badgeBackgroundColor: .btnPrimary,
            badgeTextColor: .textPrimary,
            badgeSize: 30,
            shadowColor: .black.withAlphaComponent(0.6),
            shadowOffset: CGSize(width: 0, height: 5),
            shadowRadius: 8
        )
    }
}
