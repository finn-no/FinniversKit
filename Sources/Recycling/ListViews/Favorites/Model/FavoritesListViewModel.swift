//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol FavoritesListViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var detail: String { get }
    var title: String { get }
    var accessibilityLabel: String { get }
}

public extension FavoritesListViewModel {
    var accessibilityLabel: String {
        var message = detail
        message += ". " + title
        return message
    }
}
