//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol RibbonModel {
    var type: RibbonType { get }
    var accessibilityLabel: String { get }
    var title: String { get }
}

public extension RibbonModel {
    var accessibilityLabel: String {
        return title
    }
}
