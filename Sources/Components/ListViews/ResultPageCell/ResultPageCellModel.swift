//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ResultPageCellModel {
    var iconImage: UIImage? { get }
    var showExternalLinkIcon: Bool { get }
    var badgeImage: UIImage? { get }
    var title: String { get }
    var accessibilityLabel: String { get }
}

public extension ResultPageCellModel {
    var accessibilityLabel: String {
        return title
    }
}
