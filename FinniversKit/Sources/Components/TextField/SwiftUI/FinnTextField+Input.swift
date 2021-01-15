//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension FinnTextField {
    public enum Input {
        case `default`
        case secure
        case email
        case phone
        case number

        var keyboardType: UIKeyboardType {
            switch self {
            case .email: return .emailAddress
            case .phone: return .phonePad
            case .number: return .numberPad
            default: return .default
            }
        }

        var returnKeyType: UIReturnKeyType {
            .default
        }

        var textContentType: UITextContentType? {
            switch self {
            case .email: return .emailAddress
            case .phone: return .telephoneNumber
            case .secure: return .password
            default: return nil
            }
        }
    }
}
