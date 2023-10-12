//
//  Copyright © 2023 FINN AS. All rights reserved.
//

import Foundation
import SwiftUI

public protocol SettingsViewIconCellModel: SettingsViewCellModel {
    var icon: (image: UIImage, tintColor: Color?) { get }
}

extension SettingsViewIconCellModel {
    public var subtitle: String? {
        return nil
    }

    public var detailText: String? {
        return nil
    }

    public var hasChevron: Bool {
        return false
    }
}
