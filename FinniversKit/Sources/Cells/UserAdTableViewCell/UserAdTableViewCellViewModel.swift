//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol UserAdTableViewCellViewModel {
    var titleText: String { get }
    var subtitleText: String? { get }
    var detailText: String? { get }
    var imagePath: String? { get }
    var ribbonViewModel: RibbonViewModel { get }
    var actionViewModel: UserAdTableViewCellActionViewModel? { get }
    var ratingViewModel: UserAdTableViewCellRatingViewModel? { get }
}

public extension UserAdTableViewCellViewModel {
    var accessibilityLabel: String {
        var message = titleText
        message += ". " + (subtitleText ?? "")
        message += ". " + ribbonViewModel.title
        message += ". " + (detailText ?? "")
        return message
    }
}

public protocol UserAdTableViewCellActionViewModel {
    var title: String? { get }
    var description: String { get }
    var buttonTitle: String { get }
    var cancelButtonTitle: String? { get }
    var isExternalAction: Bool { get }
}

public extension UserAdTableViewCellActionViewModel {
    var isExternalAction: Bool { false }
}

public protocol UserAdTableViewCellRatingViewModel {
    var title: String { get }
    var feedbackText: String { get }
}
