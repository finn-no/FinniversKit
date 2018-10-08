//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension BroadcastItem {
    struct Style {
        static let backgroundColor = UIColor.banana
        static let containerCornerRadius: CGFloat = 8.0
        static let fontAttributes = [
            NSAttributedString.Key.font: UIFont.body,
            NSAttributedString.Key.foregroundColor: UIColor.licorice,
        ]
        static let linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primaryBlue]
    }
}
