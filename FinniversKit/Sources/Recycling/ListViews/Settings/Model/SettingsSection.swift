//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public enum SettingsHeaderType {
    case complex(title: String, subtitle: String, image: UIImage)
    case plain(title: String)
}

public struct SettingsSection {
    public let header: SettingsHeaderType?
    public var items: [SettingsViewCellModel]
    public let footerTitle: String?

    public init(header: SettingsHeaderType? = nil, items: [SettingsViewCellModel], footerTitle: String? = nil) {
        self.header = header
        self.items = items
        self.footerTitle = footerTitle
    }
}
