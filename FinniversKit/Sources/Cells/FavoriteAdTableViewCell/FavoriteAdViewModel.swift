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
    public let ribbonViewModel: RibbonViewModel?
    public let sortingDetailText: String?
    public let addedToFolderDate: Date
    public let lastUpdated: Date?
    public let comment: String?
    /// Title displayed above the per-ad note in the Warp.Alert. Consumers supply
    /// their own localized string ("Notat" / "Note" / etc). Defaults to empty
    /// for backwards-compat; the cell hides the alert when comment itself is nil.
    public let commentAlertTitle: String

    public init(addressText: String?,
                titleText: String,
                titleColor: UIColor,
                descriptionPrimaryText: String?,
                descriptionSecondaryText: String?,
                descriptionTertiaryText: String?,
                imagePath: String?,
                ribbonViewModel: RibbonViewModel?,
                sortingDetailText: String?,
                addedToFolderDate: Date,
                lastUpdated: Date?,
                comment: String?,
                commentAlertTitle: String = "") {
        self.addressText = addressText
        self.titleText = titleText
        self.titleColor = titleColor
        self.descriptionPrimaryText = descriptionPrimaryText
        self.descriptionSecondaryText = descriptionSecondaryText
        self.descriptionTertiaryText = descriptionTertiaryText
        self.imagePath = imagePath
        self.ribbonViewModel = ribbonViewModel
        self.sortingDetailText = sortingDetailText
        self.addedToFolderDate = addedToFolderDate
        self.lastUpdated = lastUpdated
        self.comment = comment
        self.commentAlertTitle = commentAlertTitle
    }
}
