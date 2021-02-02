//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

public protocol JobRecommendationModel: AdRecommendationVariant {
    var company: String { get }
    var location: String { get }
    var publishedRelative: String? { get }
    var ribbonOverlayModel: RibbonViewModel? { get }
}

public extension JobRecommendationModel {
    var accessibilityLabel: String {
        title // TODO: Improve
    }

    var locationAndPublishedRelative: String {
        var text = location.trimmingCharacters(in: .whitespaces)

        if let time = publishedRelative {
            text += " • \(time)"
        }

        return text
    }
}
