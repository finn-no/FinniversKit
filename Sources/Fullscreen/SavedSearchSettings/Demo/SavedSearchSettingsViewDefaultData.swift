//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SavedSearchSettingsViewDefaultData: SavedSearchSettingsViewModel {
    public let name = "Logg inn for å sende meldinger, lagre favoritter og søk. Du får også varsler når det skjer noe nytt!"
    public let namePlaceholder = "E-post"
    public let isAppNotificationEnabled = true
    public let isEmailNotificationEnabled = true
    public let deleteButtonTitle = "Logg inn"

    public init() {}
}
