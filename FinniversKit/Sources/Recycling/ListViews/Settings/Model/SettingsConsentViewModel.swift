//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public struct SettingsConsentViewModel: BasicTableViewCellViewModel, Equatable, Hashable {
    public let id: String?
    public let title: String
    public let status: String
    public let subtitle: String? = nil
    public let detailText: String? = nil
    public let hasChevron = true

    public init(id: String? = nil, title: String, status: String) {
        self.id = id
        self.title = title
        self.status = status
    }
}
