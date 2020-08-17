//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct OptionCellViewModel {
    public var title: String
    public var icon: UIImage
    public var accessibilityLabel: String?
    public var accessibilityHint: String?

    public init(
        title: String,
        icon: UIImage,
        accessibilityLabel: String? = nil,
        accessibilityHint: String? = nil
    ) {
        self.title = title
        self.icon = icon
        self.accessibilityLabel = accessibilityLabel
        self.accessibilityHint = accessibilityHint
    }
}
