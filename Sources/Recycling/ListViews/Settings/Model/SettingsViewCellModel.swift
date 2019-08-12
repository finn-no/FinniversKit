//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public protocol SettingsViewCellModel {
    var title: String { get }
    var status: String? { get set }
    var hasChevron: Bool { get }
}
