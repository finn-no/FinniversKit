//
//  Copyright © 2019 FINN AS. All rights reserved.
//
import Warp

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
            case .tips: return Warp.UIColor.badgeSponsoredBackground
            case .newFunctionality: return .backgroundPositiveSubtle
            case .success: return .backgroundPositiveSubtle
            case .warning: return .backgroundWarningSubtle
            case .error: return .backgroundNegativeSubtle
            }
        }

        var borderColor: UIColor? {
            switch self {
            case .newFunctionality: return .borderPositive
            default: return nil
            }
        }

        var textColor: UIColor {
            switch self {
            case .tips, .newFunctionality, .success, .warning, .error: return .text
            default: return .text
            }
        }
    }
}
