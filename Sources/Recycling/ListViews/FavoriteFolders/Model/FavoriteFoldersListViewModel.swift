//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol FavoriteFoldersListViewModel {
    var title: String { get }
    var detail: String { get }
    var imageUrl: String { get }
    var accessibilityLabel: String { get }
}

public extension FavoriteFoldersListViewModel {
    var accessibilityLabel: String {
        var message = detail
        message += ". " + title
        return message
    }
}
