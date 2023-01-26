//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol SettingsViewConsentCellModel: SettingsViewCellModel, Identifiable {
    var id: String { get }
    var status: String { get }
}
