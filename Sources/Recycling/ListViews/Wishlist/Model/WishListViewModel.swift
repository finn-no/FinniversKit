//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol WishListViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var leftImageDetail: String { get }
    var rightImageDetail: String { get }
    var leftSubtitleDetail: String { get }
    var rightSubtitleDetail: String { get }
    var title: String { get }
    var accessibilityLabel: String { get }
}

public extension WishListViewModel {
    var accessibilityLabel: String {
        var message = leftImageDetail
        message += ". " + rightImageDetail
        message += ". " + leftSubtitleDetail
        message += ". " + rightSubtitleDetail
        message += ". " + title
        return message
    }
}
