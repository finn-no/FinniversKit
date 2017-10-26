//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Label {

    public enum Style {
        case title1
        case title2
        case title3
        case title4(FlexibleColorGroup)
        case title5(FlexibleColorGroup)
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
            case .title1: return .licorice
            case .title2: return .licorice
            case .title3: return .licorice
            case let .title4(colorGroup): return colorGroup.color
            case let .title5(colorGroup): return colorGroup.color
            case let .body(colorGroup): return colorGroup.color
            case let .detail(colorGroup): return colorGroup.color
            }
        }

        var font: UIFont {
            switch self {
            case .title1: return UIFont.title1
            case .title2: return UIFont.title2
            case .title3: return UIFont.title3
            case .title4: return UIFont.title4
            case .title5: return UIFont.title5
            case .body: return UIFont.body
            case .detail: return UIFont.detail
            }
        }

        var padding: UIEdgeInsets {
            return UIEdgeInsets(top: lineSpacing, left: 0, bottom: 0, right: 0)
        }

        var lineSpacing: CGFloat {
            switch self {
            case .title1: return font.pointSize * 0.5
            case .title2: return font.pointSize * 0.5
            case .title3: return font.pointSize * 0.5
            default: return 0
            }
        }
    }
}
