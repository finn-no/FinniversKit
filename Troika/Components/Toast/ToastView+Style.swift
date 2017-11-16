//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension ToastView {
    public enum Style {
        case success
        case sucesssImage
        case error
        case successButton
        case errorButton

        var color: UIColor {
            switch self {
            case .error, .errorButton: return .salmon
            default: return .mint
            }
        }

        var imageBackgroundColor: UIColor {
            switch self {
            case .sucesssImage: return .milk
            default: return .clear
            }
        }
    }
}
