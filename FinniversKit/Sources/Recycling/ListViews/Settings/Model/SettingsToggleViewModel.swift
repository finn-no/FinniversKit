//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public struct SettingsToggleViewModel: BasicTableViewCellViewModel, Equatable, Hashable {
    public let id: String?
    public let title: String
    public var isOn: Bool
    public let subtitle: String? = nil
    public let detailText: String? = nil
    public let hasChevron = false

    public init(id: String? = nil, title: String, isOn: Bool) {
        self.id = id
        self.title = title
        self.isOn = isOn
    }
}
