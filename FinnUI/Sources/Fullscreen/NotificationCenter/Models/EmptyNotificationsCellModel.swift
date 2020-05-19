//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public struct EmptyNotificationsCellModel {
    public enum Kind {
        case personal
        case savedSearch
    }

    public let kind: Kind
    public let title: String
    public let body: String

    public init(kind: Kind, title: String, body: String) {
        self.kind = kind
        self.title = title
        self.body = body
    }

    var icon: UIImage {
        switch kind {
        case .personal: return UIImage(named: .emptyPersonalNotificationsIcon)
        case .savedSearch: return UIImage(named: .emptySavedSearchNotificationsIcon)
        }
    }
}
