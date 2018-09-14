//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SavedSearchSettingsViewDefaultData: SavedSearchSettingsViewModel {
    public let name: String? = nil
    public let namePlaceholder = "Navn på søket"
    public let isAppNotificationEnabled = false
    public let isEmailNotificationEnabled = false
    public let deleteButtonTitle = "Slett lagret søk"

    public init() {}
}
