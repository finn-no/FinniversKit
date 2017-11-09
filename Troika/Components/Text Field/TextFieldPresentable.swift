//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol TextFieldPresentable {
    var type: TextFieldType { get }
    var accessibilityLabel: String { get }
}

public extension TextFieldPresentable {
    var accessibilityLabel: String {
        return type.typeText
    }
}
