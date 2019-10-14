//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol UserAdsListViewModel {
    var imagePath: String? { get }
    var imageSize: CGSize { get }
    var title: String { get }
    var price: String? { get }
    var detail: String { get }
    var status: String { get }
    var accessibilityLabel: String { get }
    var actionViewModel: UserAdsListActionViewModel? { get }
    var ratingViewModel: UserAdsListRatingViewModel? { get }
}

public extension UserAdsListViewModel {
    var accessibilityLabel: String {
        var message = title
        message += ". " + (price ?? "")
        message += ". " + status
        message += ". " + detail
        return message
    }
}

public protocol UserAdsListActionViewModel {
    var title: String? { get }
    var description: String { get }
    var buttonTitle: String { get }
    var cancelButtonTitle: String? { get }
}

public protocol UserAdsListRatingViewModel {
    var title: String { get }
    var feedbackText: String { get }
}
