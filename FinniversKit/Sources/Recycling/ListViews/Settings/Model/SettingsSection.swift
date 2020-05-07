//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct SettingsSection: Equatable, Hashable {
    public let title: String?
    public var rows: [SettingsRow]
    public let footerTitle: String?

    public init(title: String?, rows: [SettingsRowConvertible], footerTitle: String? = nil) {
        self.init(title: title, rows: rows.map({ $0.row }), footerTitle: footerTitle)
    }

    public init(title: String?, rows: [SettingsRow], footerTitle: String? = nil) {
        self.title = title
        self.rows = rows
        self.footerTitle = footerTitle
    }
}

public enum SettingsRow: SettingsRowConvertible, Equatable, Hashable {
    case text(SettingsTextViewModel)
    case consent(SettingsConsentViewModel)
    case toggle(SettingsToggleViewModel)

    public var row: SettingsRow { self }
}

public protocol SettingsRowConvertible {
    var row: SettingsRow { get }
}
