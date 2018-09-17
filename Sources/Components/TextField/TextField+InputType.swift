//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension TextField {
    public enum InputType {
        case normal
        case email
        case password

        var isSecureTextEntry: Bool {
            switch self {
            case .password: return true
            default: return false
            }
        }

        var keyboardType: UIKeyboardType {
            switch self {
            case .normal: return .default
            case .email: return .emailAddress
            case .password: return .asciiCapable
            }
        }

        var autocapitalizationType: UITextAutocapitalizationType {
            switch self {
            case .normal: return .words
            case .email: return .none
            case .password: return .none
            }
        }

        var autocorrectionType: UITextAutocorrectionType {
            switch self {
            case .normal: return .default
            case .email: return .no
            case .password: return .no
            }
        }

        var returnKeyType: UIReturnKeyType {
            switch self {
            case .email: return .next
            case .normal, .password: return .done
            }
        }
    }
}
