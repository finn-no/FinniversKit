//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol AdsGridViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var iconImage: UIImage? { get }
    var title: String { get }
    var subtitle: String? { get }
    var accessory: String? { get }
    var imageText: String? { get }
    var accessibilityLabel: String { get }
    var isFavorite: Bool { get }
    var favoriteButtonAccessibilityLabel: String { get }
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
