import Foundation

public extension Label {

    public enum Style {
        case t1
        case t2
        case t3
        case t4(FlexibleColorGroup)
        case t5(FlexibleColorGroup)
        case body(AllColorGroup)
        case detail(AllColorGroup)

        public enum FlexibleColorGroup {
            case licorice
            case milk

            var color: UIColor {
                switch self {
                case .licorice: return .licorice
                case .milk: return .milk
                }
            }
        }

        public enum AllColorGroup {
            case licorice
            case milk
            case stone
            case primaryBlue
            case cherry

            var color: UIColor {
                switch self {
                case .licorice: return .licorice
                case .milk: return .milk
                case .stone: return .stone
                case .primaryBlue: return .primaryBlue
                case .cherry: return .cherry
                }
            }
        }

        var color: UIColor {
            switch self {
            case .t1: return .licorice
            case .t2: return .licorice
            case .t3: return .licorice
            case let .t4(colorGroup): return colorGroup.color
            case let .t5(colorGroup): return colorGroup.color
            case let .body(colorGroup): return colorGroup.color
            case let .detail(colorGroup): return colorGroup.color
            }
        }

        var font: UIFont {
            switch self {
            case .t1: return UIFont.t1
            case .t2: return UIFont.t2
            case .t3: return UIFont.t3
            case .t4: return UIFont.t4
            case .t5: return UIFont.t5
            case .body: return UIFont.body
            case .detail: return UIFont.detail
            }
        }

        var padding: UIEdgeInsets {
            return UIEdgeInsets(top: lineSpacing, left: 0, bottom: 0, right: 0)
        }

        var lineSpacing: CGFloat {
            switch self {
            case .t1: return font.pointSize * 0.5
            case .t2: return font.pointSize * 0.5
            case .t3: return font.pointSize * 0.5
            default: return 0
            }
        }
    }
}
