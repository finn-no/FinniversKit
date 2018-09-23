//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SavedSearchSettingsViewDefaultData: SavedSearchSettingsViewModel {
    public let name: String? = "Business fun"
    public let namePlaceholder = "Navn på søket"
    public let deleteButtonTitle = "Slett lagret søk"
    public var appSwitchModel: SwitchViewModel = SavedSearchSwitchViewModel(title: "Appvarsling", subtitle: "Something about on", isOn: true)
    public var emailSwitchModel: SwitchViewModel = SavedSearchSwitchViewModel(title: "E-postvarsling", subtitle: nil, isOn: false)

    public init() {}
}

public struct SavedSearchSwitchViewModel: SwitchViewModel {
    public var title: String
    public var subtitle: String?
    public var isOn: Bool

    init(title: String, subtitle: String?, isOn: Bool) {
        self.title = title
        self.subtitle = subtitle
        self.isOn = isOn
    }
}
