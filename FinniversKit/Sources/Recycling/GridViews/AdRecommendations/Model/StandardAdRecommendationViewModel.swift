//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

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
    var favoriteButtonAccessibilityLabel: String { get }
    var hideImageOverlay: Bool { get }
    var badgeViewModel: BadgeViewModel? { get }
}

public struct SponsoredAdData {
    public let ribbonTitle: String
    public let logoImagePath: String?

    public init(ribbonTitle: String, logoImagePath: String?) {
        self.ribbonTitle = ribbonTitle
        self.logoImagePath = logoImagePath
    }
}
