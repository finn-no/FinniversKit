//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public struct SettingsTextViewModel: BasicTableViewCellViewModel, Equatable, Hashable {
    public let title: String
    public let hasChevron: Bool
    public let subtitle: String? = nil
    public let detailText: String? = nil

    public init(title: String, hasChevron: Bool = true) {
        self.title = title
        self.hasChevron = hasChevron
    }
}
