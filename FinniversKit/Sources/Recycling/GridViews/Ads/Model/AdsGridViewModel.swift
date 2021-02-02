//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol AdsGridViewModel: AdRecommendationVariant {
    var subtitle: String? { get }
    var imageSize: CGSize { get }
    var iconImage: UIImage? { get }
    var accessory: String? { get }
    var imageText: String? { get }
    var scaleImageToFillView: Bool { get }
    var sponsoredAdData: SponsoredAdData? { get }
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
