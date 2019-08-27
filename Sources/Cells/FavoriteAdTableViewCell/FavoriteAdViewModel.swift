//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct FavoriteAdViewModel {
    public let addressText: String?
    public let titleText: String
    public let titleColor: UIColor
    public let descriptionPrimaryText: String?
    public let descriptionSecondaryText: String?
    public let imagePath: String?
    public let ribbonStyle: RibbonView.Style
    public let ribbonTitle: String
    public let addedToFolderDate: Date
    public let lastUpdated: Date?

    public init(addressText: String?,
                titleText: String,
                titleColor: UIColor,
                descriptionPrimaryText: String?,
                descriptionSecondaryText: String?,
                imagePath: String?,
                ribbonStyle: RibbonView.Style,
                ribbonTitle: String,
                addedToFolderDate: Date,
                lastUpdated: Date?) {
        self.addressText = addressText
        self.titleText = titleText
        self.titleColor = titleColor
        self.descriptionPrimaryText = descriptionPrimaryText
        self.descriptionSecondaryText = descriptionSecondaryText
        self.imagePath = imagePath
        self.ribbonStyle = ribbonStyle
        self.ribbonTitle = ribbonTitle
        self.addedToFolderDate = addedToFolderDate
        self.lastUpdated = lastUpdated
    }
}
