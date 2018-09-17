//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SavedSearchSettingsViewModel {
    var name: String? { get }
    var namePlaceholder: String { get }

    var appSwitchTitle: String { get }
    var isAppNotificationEnabled: Bool { get }

    var emailSwitchTitle: String { get }
    var isEmailNotificationEnabled: Bool { get }

    var deleteButtonTitle: String { get }
}

public extension SavedSearchSettingsViewModel {
    var accessibilityLabel: String {
        return ""
    }
}
