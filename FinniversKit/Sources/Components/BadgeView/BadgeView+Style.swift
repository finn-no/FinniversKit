import Foundation

public extension BadgeView {
    enum Style: Hashable {
        case `default`
        case warning
        case sponsored

        var backgroundColor: UIColor {
            switch self {
            case .default: return .bgSecondary
            case .warning: return .bgAlert
            case .sponsored: return .accentToothpaste
            }
        }

        var textColor: UIColor {
            switch self {
            case .default: return .textPrimary
            case .warning: return .warningTextColor
            case .sponsored: return .aqua800
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
