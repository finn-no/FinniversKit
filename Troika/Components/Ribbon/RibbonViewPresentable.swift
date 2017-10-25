//
//  Copyright © 2017 FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol RibbonPresentable {
    var type: RibbonType { get }
    var accessibilityLabel: String { get }
    var title: String { get }
}

public extension RibbonPresentable {
    var accessibilityLabel: String {
        return title
    }
}
