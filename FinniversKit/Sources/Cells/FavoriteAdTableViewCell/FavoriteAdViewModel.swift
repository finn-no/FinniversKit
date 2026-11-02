//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public struct FavoriteAdViewModel {
    /// The status badge shown in the top trailing corner of a favorite ad, for example "Aktiv" or "Solgt".
    public struct StatusBadge: Equatable {
        public let text: String
        public let variant: Warp.BadgeVariant

        public init(text: String, variant: Warp.BadgeVariant) {
            self.text = text
            self.variant = variant
        }
    }

    public let addressText: String?
    public let titleText: String
    public let titleColor: UIColor
    public let descriptionPrimaryText: String?
    public let descriptionSecondaryText: String?
    public let descriptionTertiaryText: String?
    public let imagePath: String?
    /// Only set by the `ribbonViewModel` initializer. `FavoriteAdView` renders `statusBadge`.
    public let ribbonViewModel: RibbonViewModel?
    public let statusBadge: StatusBadge?
    public let sortingDetailText: String?
    public let addedToFolderDate: Date
    public let lastUpdated: Date?
    public let comment: String?
    public let commentAlertTitle: String

    /// Converts `ribbonViewModel` to a `statusBadge`. A `RibbonView.Style` has no price variant,
    /// so use the `statusBadge` initializer to show any `Warp.BadgeVariant`.
    @available(*, deprecated, message: "Use init(...statusBadge:...) instead. RibbonView.Style can't express every Warp.BadgeVariant, for example .price.")
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
        self.statusBadge = ribbonViewModel.map(StatusBadge.init(ribbonViewModel:))
        self.sortingDetailText = sortingDetailText
        self.addedToFolderDate = addedToFolderDate
        self.lastUpdated = lastUpdated
        self.comment = comment
        self.commentAlertTitle = commentAlertTitle
    }

    public init(addressText: String?,
                titleText: String,
                titleColor: UIColor,
                descriptionPrimaryText: String?,
                descriptionSecondaryText: String?,
                descriptionTertiaryText: String?,
                imagePath: String?,
                statusBadge: StatusBadge?,
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
        self.ribbonViewModel = nil
        self.statusBadge = statusBadge
        self.sortingDetailText = sortingDetailText
        self.addedToFolderDate = addedToFolderDate
        self.lastUpdated = lastUpdated
        self.comment = comment
        self.commentAlertTitle = commentAlertTitle
    }
}

private extension FavoriteAdViewModel.StatusBadge {
    init(ribbonViewModel: RibbonViewModel) {
        let variant: Warp.BadgeVariant
        switch ribbonViewModel.style {
        case .default: variant = .neutral
        case .success: variant = .success
        case .warning: variant = .warning
        case .error: variant = .negative
        case .disabled: variant = .disabled
        case .sponsored: variant = .sponsored
        }
        self.init(text: ribbonViewModel.title, variant: variant)
    }
}
