//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FavoriteButtonAccessibilityData: Hashable {
    let labelInactiveState: String
    let labelActiveState: String
    let hint: String
    let iconDescription: String

    public init(
        labelInactiveState: String,
        labelActiveState: String,
        hint: String,
        iconDescription: String
    ) {
        self.labelInactiveState = labelInactiveState
        self.labelActiveState = labelActiveState
        self.hint = hint
        self.iconDescription = iconDescription
    }
}

public protocol StandardAdRecommendationViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var iconImage: UIImage? { get }
    var title: String { get }
    var subtitle: String? { get }
    var accessory: String? { get }
    var imageText: String? { get }
    var isFavorite: Bool { get }
    var scaleImageToFillView: Bool { get }
    var sponsoredAdData: SponsoredAdData? { get }
    var favoriteButtonAccessibilityData: FavoriteButtonAccessibilityData { get }
    var hideImageOverlay: Bool { get }
    var badgeViewModel: BadgeViewModel? { get }
    var companyName: String? { get }
}

public struct SponsoredAdData {
    public let ribbonTitle: String
    public let logoImagePath: String?

    public init(ribbonTitle: String, logoImagePath: String?) {
        self.ribbonTitle = ribbonTitle
        self.logoImagePath = logoImagePath
    }
}
