//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

public protocol JobAdRecommendationViewModel {
    var title: String { get }
    var company: String { get }
    var location: String { get }
    var publishedRelative: String? { get }
    var ribbonOverlayModel: RibbonViewModel? { get }
    var imagePath: String? { get }
    var isFavorite: Bool { get }
    var accessibilityLabel: String { get }
    var favoriteButtonAccessibilityLabel: String { get }
}

public extension JobAdRecommendationViewModel {
    var accessibilityLabel: String {
        [title, company, location, publishedRelative].compactMap { $0 }.joined(separator: ", ")
    }

    var locationAndPublishedRelative: String {
        var text = location.trimmingCharacters(in: .whitespaces)

        if let time = publishedRelative {
            text += " • \(time)"
        }

        return text
    }
}
