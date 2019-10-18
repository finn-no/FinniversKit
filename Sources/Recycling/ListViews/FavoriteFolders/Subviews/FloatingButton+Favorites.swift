//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension FloatingButton {
    static func favoritesXmasButton(withTarget: Any?, action: Selector) -> FloatingButton {
        let button = FloatingButton(withAutoLayout: true)
        button.backgroundColor = .cherry
        button.tintColor = .milk
        button.layer.borderWidth = .smallSpacing
        button.layer.borderColor = .milk
        button.setImage(UIImage(named: .favoriteXmas).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}
