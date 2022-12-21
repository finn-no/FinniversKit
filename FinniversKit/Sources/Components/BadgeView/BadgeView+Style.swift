import Foundation

public extension BadgeView {
    enum Style: Hashable {
        case `default`
        case alert

        var color: UIColor {
            switch self {
            case .default: return .bgSecondary
            case .alert: return .bgAlert
            }
        }

        var textColor: UIColor {
            switch self {
            case .default: return .textPrimary
            case .alert: return .alertTextColor
            }
        }
    }
}

// MARK: - Private extensions

private extension UIColor {
    class var alertTextColor: UIColor {
        UIColor(hex: "#885407")
    }
}
