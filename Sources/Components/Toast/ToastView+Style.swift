//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

extension ToastView {
    public enum Style {
        case success
        case sucesssWithImage
        case error
        case successButton
        case errorButton

        var color: UIColor {
            switch self {
            case .error, .errorButton: return .salmon
            default: return .bgSuccess
            }
        }

        var imageBackgroundColor: UIColor {
            switch self {
            case .sucesssWithImage: return .bgPrimary
            default: return .clear
            }
        }
    }
}
