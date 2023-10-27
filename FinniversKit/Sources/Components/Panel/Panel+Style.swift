//
//  Copyright © 2019 FINN AS. All rights reserved.
//

extension Panel {
    public enum Style: String {
        case plain
        case info
        case tips
        case newFunctionality = "new-functionality"
        case success
        case warning
        case error

        var backgroundColor: UIColor {
            switch self {
            case .plain: return .background
            case .info: return .backgroundInfoSubtle
            case .tips: return .accentToothpaste
            case .newFunctionality: return .bgSuccess
            case .success: return .bgSuccess
            case .warning: return .backgroundWarningSubtle
            case .error: return .bgCritical
            }
        }

        var borderColor: UIColor? {
            switch self {
            case .newFunctionality: return .accentPea
            default: return nil
            }
        }

        var textColor: UIColor {
            switch self {
            case .tips, .newFunctionality, .success, .warning, .error: return .textToast
            default: return .textPrimary
            }
        }
    }
}
