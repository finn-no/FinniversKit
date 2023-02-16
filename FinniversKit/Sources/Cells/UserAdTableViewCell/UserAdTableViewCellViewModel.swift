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
