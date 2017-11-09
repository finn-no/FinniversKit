//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension TextField {

    public enum InputType {
        case email
        case password

        var typeText: String {
            switch self {
            case .email: return "E-post:"
            case .password: return "Passord:"
            }
        }

        var placeHolder: String {
            switch self {
            case .email: return "E-post"
            case .password: return "Passord"
            }
        }

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
    }
}
