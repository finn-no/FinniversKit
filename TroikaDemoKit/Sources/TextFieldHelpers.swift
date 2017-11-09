//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Troika

public enum TextFieldDataModel: TextFieldPresentable {
    case email
    case password

    public var type: TextField.InputType {
        switch self {
        case .email: return .email
        case .password: return .password
        }
    }

    var typeText: String {
        switch self {
        case .email: return "E-post:"
        case .password: return "Passord:"
        }
    }

    public var accessibilityLabel: String {
        return "Skriv in: " + typeText
    }
}
