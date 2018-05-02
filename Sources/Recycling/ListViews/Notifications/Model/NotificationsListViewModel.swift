//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol NotificationsListViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var detail: String { get }
    var title: String { get }
    var price: String { get }
    var accessibilityLabel: String { get }
}

public extension NotificationsListViewModel {
    var accessibilityLabel: String {
        var message = detail
        message += ". " + title
        message += ". " + price

        return message
    }
}
