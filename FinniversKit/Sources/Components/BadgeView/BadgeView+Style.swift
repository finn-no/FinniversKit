import Foundation

public extension BadgeView {
    enum Style: Hashable {
        case `default`
        case fiksFerdig

        var color: UIColor {
            switch self {
            case .default: return .bgSecondary
            case .fiksFerdig: return .bgAlert
            }
        }

        var textColor: UIColor {
            switch self {
            case .default: return .textPrimary
            case .fiksFerdig: return .fiksFerdigTextColor
            }
        }
    }
}

// MARK: - Private extensions

private extension UIColor {
    class var fiksFerdigTextColor: UIColor {
        UIColor(hex: "#885407")
    }
}
