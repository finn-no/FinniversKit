//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol MarketGridModel {
    var iconImage: UIImage? { get }
    var showExternalLinkIcon: Bool { get }
    var title: String { get }
    var accessibilityLabel: String { get }
}

public extension MarketGridModel {
    var accessibilityLabel: String {
        return title
    }
}
