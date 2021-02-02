//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

public protocol AdRecommendationVariant {
    var title: String { get }
    var imagePath: String? { get }
    var isFavorite: Bool { get }
    var accessibilityLabel: String { get }
}
