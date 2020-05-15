//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol SaveSearchViewModel {
    var searchTitle: String? { get }
    var searchPlaceholderText: String { get }

    var notificationCenterSwitchViewModel: SwitchViewModel { get }
    var pushNotificationSwitchViewModel: SwitchViewModel { get }
    var emailNotificationSwitchViewModel: SwitchViewModel { get }
}
