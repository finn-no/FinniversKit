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
    public let iconImage: UIImage
    public let trailingItem: TrailingItem

    public init(title: String, iconImage: UIImage, trailingItem: TrailingItem = .none) {
        self.title = title
        self.iconImage = iconImage
        self.trailingItem = trailingItem
    }
}
