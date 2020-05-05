//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SettingsSection {
    public let title: String?
    public let items: [SettingsViewCellModel]
    public let footerTitle: String?

    public init(title: String?, items: [SettingsViewCellModel], footerTitle: String? = nil) {
        self.title = title
        self.items = items
        self.footerTitle = footerTitle
    }
}
