//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public protocol SettingsViewCellModel: BasicTableViewCellViewModel {}

extension SettingsViewCellModel {
    public var subtitle: String? {
        return nil
    }

    public var detailText: String? {
        return nil
    }

    public var hasChevron: Bool {
        return true
    }
}
