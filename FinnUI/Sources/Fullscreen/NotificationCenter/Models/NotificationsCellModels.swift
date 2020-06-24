//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCellModel {
    var isRead: Bool { get set }
    var content: NotificationCellContent? { get }
}

public protocol NotificationCellContent {
    var imagePath: String? { get }
    var title: String { get }
    var priceText: String? { get }
}

public protocol PersonalNotificationCellContent: NotificationCellContent {
    var description: String { get }
    var icon: PersonalNotificationIconView.Kind { get }
}

public protocol SavedSearchNotificationCellContent: NotificationCellContent {
    var locationText: String { get }
    var ribbonViewModel: RibbonViewModel? { get }
}

public protocol FavoriteSoldNotificationCellContent: PersonalNotificationCellContent {
    var ribbonViewModel: RibbonViewModel? { get }
    var detail: String? { get }
}
