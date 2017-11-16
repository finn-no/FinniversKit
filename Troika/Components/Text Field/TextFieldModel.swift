//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol TextFieldModel {
    var type: TextField.InputType { get }
    var accessibilityLabel: String { get }
}

public extension TextFieldModel {
    var accessibilityLabel: String {
        return type.typeText
    }
}
