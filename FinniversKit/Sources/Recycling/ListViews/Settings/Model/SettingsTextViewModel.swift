//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public struct SettingsTextViewModel: BasicTableViewCellViewModel, Equatable, Hashable {
    public let id: String?
    public let title: String
    public let hasChevron: Bool
    public let subtitle: String? = nil
    public let detailText: String? = nil

    public init(id: String? = nil, title: String, hasChevron: Bool = true) {
        self.id = id
        self.title = title
        self.hasChevron = hasChevron
    }
}
