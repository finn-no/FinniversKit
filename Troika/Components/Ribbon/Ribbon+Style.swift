//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension RibbonView {
    public enum Style {
        case ordinary
        case success
        case warning
        case error
        case disabled
        case sponsored

        var color: UIColor {
            switch self {
            case .ordinary: return .ice
            case .success: return .mint
            case .warning: return .banana
            case .error: return .salmon
            case .disabled: return .sardine
            case .sponsored: return .toothPaste
            }
        }
    }
}
