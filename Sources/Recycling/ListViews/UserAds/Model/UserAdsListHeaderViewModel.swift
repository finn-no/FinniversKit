//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol UserAdsListHeaderViewModel {
    var title: String { get }
    var buttonTitle: String { get }
    var accessibilityLabel: String { get }
}

public extension UserAdsListHeaderViewModel {
    var accessibilityLabel: String {
        var message = title
        message += ". " + buttonTitle
        return message
    }
}
