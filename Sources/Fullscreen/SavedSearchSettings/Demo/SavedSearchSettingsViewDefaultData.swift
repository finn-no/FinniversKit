//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SavedSearchSettingsViewDefaultData: SavedSearchSettingsViewModel {
    public let name: String? = "Business fun"
    public let namePlaceholder = "Navn på søket"
    public let deleteButtonTitle = "Slett lagret søk"
    public var appSwitchModel: SwitchViewModel = SavedSearchSwitchViewModel(headerText: "Appvarsling", isOn: false)
    public var emailSwitchModel: SwitchViewModel = SavedSearchSwitchViewModel(headerText: "E-postvarsling", isOn: false)

    public init() {}
}

public struct SavedSearchSwitchViewModel: SwitchViewModel {
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
