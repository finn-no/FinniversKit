//
//  Copyright © 2019 FINN AS. All rights reserved.
//

extension Panel {
    public enum Style {
        case plain
        case info
        case tips
        case newFunctionality
        case success
        case warning
        case error

        var backgroundColor: UIColor {
            switch self {
            case .plain: return .bgPrimary
            case .info: return .bgSecondary
            case .tips: return .toothPaste
            case .newFunctionality: return .mint
            case .success: return .mint
            case .warning: return .banana
            case .error: return .salmon
            }
        }

        var borderColor: UIColor? {
            switch self {
            case .newFunctionality: return .pea
            default: return nil
            }
        }

        var textColor: UIColor {
            switch self {
            default: return .licorice
            }
        }
    }
}
