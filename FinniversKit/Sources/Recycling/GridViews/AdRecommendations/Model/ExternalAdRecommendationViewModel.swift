//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ExternalAdRecommendationViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var title: String { get }
    var subtitle: String? { get }
    var scaleImageToFillView: Bool { get }
    var ribbonViewModel: RibbonViewModel? { get }
    var accessibilityLabel: String { get }
}

public extension ExternalAdRecommendationViewModel {
    var accessibilityLabel: String {
        var message = title

        if let subtitle = subtitle {
            message += ". " + subtitle
        }

        return message
    }
}
