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
    public let descriptionTertiaryText: String?
    public let imagePath: String?
    public let ribbonStyle: RibbonView.Style
    public let ribbonTitle: String
    public let sortingDetailText: String?
    public let addedToFolderDate: Date
    public let lastUpdated: Date?
    public let comment: String?

    public init(addressText: String?,
                titleText: String,
                titleColor: UIColor,
                descriptionPrimaryText: String?,
                descriptionSecondaryText: String?,
                descriptionTertiaryText: String?,
                imagePath: String?,
                ribbonStyle: RibbonView.Style,
                ribbonTitle: String,
                sortingDetailText: String?,
                addedToFolderDate: Date,
                lastUpdated: Date?,
                comment: String?) {
        self.addressText = addressText
        self.titleText = titleText
        self.titleColor = titleColor
        self.descriptionPrimaryText = descriptionPrimaryText
        self.descriptionSecondaryText = descriptionSecondaryText
        self.descriptionTertiaryText = descriptionTertiaryText
        self.imagePath = imagePath
        self.ribbonStyle = ribbonStyle
        self.ribbonTitle = ribbonTitle
        self.sortingDetailText = sortingDetailText
        self.addedToFolderDate = addedToFolderDate
        self.lastUpdated = lastUpdated
        self.comment = comment
    }
}
