//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public struct SettingsTextViewModel: BasicTableViewCellViewModel, Equatable, Hashable {
    public let title: String
    public let subtitle: String? = nil
    public let detailText: String? = nil
    public let hasChevron = true

    public init(title: String) {
        self.title = title
    }
}
