//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension TextField {
    public enum InputType {
        case normal
        case email
        case password
        case multiline

        var isSecureMode: Bool {
            switch self {
            case .password: return true
            default: return false
            }
        }

        var keyBoardStyle: UIKeyboardType {
            switch self {
            case .email: return .emailAddress
            default: return .default
            }
        }

        var returnKeyType: UIReturnKeyType {
            switch self {
            case .email: return .next
            case .normal, .password, .multiline: return .done
            }
        }
    }
}
