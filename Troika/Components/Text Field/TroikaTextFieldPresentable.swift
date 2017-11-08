//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol TroikaTextFieldPresentable {
    var type: TextFieldType { get }
    var accessibilityLabel: String { get }
}

public extension TroikaTextFieldPresentable {
    var accessibilityLabel: String {
        return ""
    }
}
