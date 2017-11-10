//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ButtonPresentable {
    var title: String { get }
    var type: Button.ButtonType { get }
    var accessibilityLabel: String { get }
}

public extension ButtonPresentable {
    var accessibilityLabel: String {
        return title
    }
}
