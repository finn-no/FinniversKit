//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SavedSearchSettingsViewModel {
    var name: String? { get }
    var namePlaceholder: String { get }
    var appSwitchModel: SwitchViewModel { get }
    var emailSwitchModel: SwitchViewModel { get }
    var deleteButtonTitle: String { get }
}

public extension SavedSearchSettingsViewModel {
    var accessibilityLabel: String {
        return ""
    }
}
