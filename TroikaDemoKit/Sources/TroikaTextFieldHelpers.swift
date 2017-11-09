//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Troika

public enum TroikaTextFieldType: TroikaTextFieldPresentable {
    case normal
    case email
    case password

    public var type: TextFieldType {
        switch self {
        case .normal: return .normal
        case .email: return .email
        case .password: return .password
        }
    }
}
