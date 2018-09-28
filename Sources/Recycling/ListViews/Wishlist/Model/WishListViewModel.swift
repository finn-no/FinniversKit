//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol WishListViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var priceLabel: String { get }
    var statusLabel: String { get }
    var recentUpdateLabel: String { get }
    var locationLabel: String { get }
    var title: String { get }
    var accessibilityLabel: String { get }
}

public extension WishListViewModel {
    var accessibilityLabel: String {
        var message = priceLabel
        message += ". " + statusLabel
        message += ". " + recentUpdateLabel
        message += ". " + locationLabel
        message += ". " + title
        return message
    }
}
