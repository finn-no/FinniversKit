//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol SaveSearchViewModel {
    var searchTitle: String? { get }
    var searchPlaceholderText: String { get }
    var deleteSearchButtonTitle: String? { get }

    var notificationCenterSwitchViewModel: SwitchViewModel { get }
    var pushSwitchViewModel: SwitchViewModel { get }
    var emailSwitchViewModel: SwitchViewModel { get }
}
