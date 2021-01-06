//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension FinnTextField {
    public enum Input {
        case `default`
        case email
        case secure

        var keyboardType: UIKeyboardType {
            switch self {
            case .email: return .emailAddress
            default: return .default
            }
        }

        var returnKeyType: UIReturnKeyType {
            .done
        }

        var textContentType: UITextContentType? {
            switch self {
            case .email: return .emailAddress
            case .secure: return .password
            default: return nil
            }
        }
    }
}
