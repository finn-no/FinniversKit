//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SavedSearchSettingsViewDefaultData: SavedSearchSettingsViewModel {
    public let name: String? = nil
    public let namePlaceholder = "Navn på søket"
    public let appSwitchTitle = "Appvarsling"
    public let isAppNotificationEnabled = false
    public let emailSwitchTitle = "E-postvarsling"
    public let isEmailNotificationEnabled = false
    public let deleteButtonTitle = "Slett lagret søk"
    public let isOn = false

    public init() {}
}

public struct AppSwitchViewModel: SwitchViewModel {
    public var headerText: String
    public var onDescriptionText: String?
    public var offDescriptionText: String?
    public var isOn: Bool

    init(headerText: String, isOn: Bool) {
        self.headerText = headerText
        self.isOn = isOn
        self.onDescriptionText = nil
        self.offDescriptionText = nil
    }
}
