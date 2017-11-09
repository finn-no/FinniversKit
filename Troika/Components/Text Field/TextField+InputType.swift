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
            var tempText = typeText
            tempText.remove(at: typeText.index(before: typeText.endIndex))
            return tempText
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
