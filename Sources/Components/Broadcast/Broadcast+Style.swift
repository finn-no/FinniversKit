//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension Broadcast {
    struct Style {
        static let backgroundColor = UIColor.banana
        static let containerCornerRadius: CGFloat = 8.0
        static let fontAttributes = [
            NSAttributedStringKey.font: UIFont.body,
            NSAttributedStringKey.foregroundColor: UIColor.licorice,
        ]
        static let linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.primaryBlue]
    }
}
