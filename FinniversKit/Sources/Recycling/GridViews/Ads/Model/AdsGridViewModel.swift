//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol AdRecommendationVariant {
    var title: String { get }
    var imagePath: String? { get }
    var isFavorite: Bool { get }
    var accessibilityLabel: String { get }
}

public protocol JobRecommendationModel: AdRecommendationVariant {
    var company: String { get }
    var location: String { get }
    var relativeTime: String? { get }
}

public protocol AdsGridViewModel: AdRecommendationVariant {
    var subtitle: String? { get }
    var imageSize: CGSize { get }
    var iconImage: UIImage? { get }
    var accessory: String? { get }
    var imageText: String? { get }
    var scaleImageToFillView: Bool { get }
    var sponsoredAdData: SponsoredAdData? { get }
    var favoriteButtonAccessibilityLabel: String { get }
}

public struct SponsoredAdData {
    public let ribbonTitle: String
    public let logoImagePath: String?

    public init(ribbonTitle: String, logoImagePath: String?) {
        self.ribbonTitle = ribbonTitle
        self.logoImagePath = logoImagePath
    }
}

public extension AdsGridViewModel {
    var accessibilityLabel: String {
        var message = title

        if let subtitle = subtitle {
            message += ". " + subtitle
        }

        if let imageText = imageText {
            message += ". " + imageText
        }

        return message
    }
}

public extension JobRecommendationModel {
    var accessibilityLabel: String {
        title // TODO: Improve
    }

    var locationAndTimeText: String {
        var text = location

        if let time = relativeTime {
            text = text.trimmingCharacters(in: .whitespaces) + " • \(time)"
        }

        return text
    }
}
