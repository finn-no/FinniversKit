//
//  Copyright © FINN.no AS. All rights reserved.
//

import Foundation

public struct AdManagementActionCellModel {
    public enum TrailingItem {
        case none
        case external
        case chevron
        case toggle
    }

    public let title: String
    public let description: String?
    public let iconImage: UIImage
    public let trailingItem: TrailingItem

    public init(title: String, description: String? = nil, iconImage: UIImage, trailingItem: TrailingItem = .none) {
        self.title = title
        self.description = description
        self.iconImage = iconImage
        self.trailingItem = trailingItem
    }
}
