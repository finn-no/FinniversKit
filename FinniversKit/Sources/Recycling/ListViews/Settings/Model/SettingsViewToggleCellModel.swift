//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol SettingsViewToggleCellModel: SettingsViewCellModel {
    var isOn: Bool { get }
}

extension SettingsViewToggleCellModel {
    public var hasChevron: Bool {
        return false
    }
}
