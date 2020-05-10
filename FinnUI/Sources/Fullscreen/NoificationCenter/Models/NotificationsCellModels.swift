//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public protocol NotificationCellModel {
    var isRead: Bool { get }
    var content: NotificationCellContent { get }
}

public protocol NotificationCellContent {
    var imagePath: String? { get }
    var title: String { get }
    var subtitle: String { get }
    var price: String { get }
}

public protocol PersonalNotificationCellContent: NotificationCellContent {
    var icon: PersonalNotificationIconView.Kind { get }
}

public protocol SavedSearchNotificationCellContent: NotificationCellContent {
    var ribbonViewModel: RibbonViewModel? { get }
}
