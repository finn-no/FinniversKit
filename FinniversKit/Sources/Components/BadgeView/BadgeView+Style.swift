import Foundation

public extension BadgeView {
    enum Style: Hashable {
        case `default`
        case warning

        var color: UIColor {
            switch self {
            case .default: return .bgSecondary
            case .warning: return .bgAlert
            }
        }

        var textColor: UIColor {
            switch self {
            case .default: return .textPrimary
            case .warning: return .warningTextColor
            }
        }
    }
}

// MARK: - Private extensions

private extension UIColor {
    class var warningTextColor: UIColor {
        UIColor(hex: "#885407")
    }
}
