//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

enum NewMarketsGridViewLayoutConfiguration {
    case small
    case medium
    case large

    static let mediumRange: Range<CGFloat> = (375.0 ..< 415.0)
    static let portraitModeScreenWidth = CGFloat(768)

    init(width: CGFloat) {
        switch width {
        case let width where width > MarketsGridViewLayoutConfiguration.mediumRange.upperBound:
            self = .large
        case let width where width < MarketsGridViewLayoutConfiguration.mediumRange.lowerBound:
            self = .small
        default:
            self = .medium
        }
    }

    var interimSpacing: CGFloat {
        switch self {
        case .large:
            return .spacingS
        default:
            return .spacingS
        }
    }

    var sideMargins: CGFloat {
        switch self {
        case .large:
            return .spacingM
        default:
            return .spacingM
        }
    }

    var edgeInsets: UIEdgeInsets {
        switch self {
        case .large:
            return UIEdgeInsets(top: 0, left: sideMargins, bottom: 0, right: sideMargins)
        default:
            return UIEdgeInsets(top: 0, left: sideMargins, bottom: 0, right: sideMargins)
        }
    }

    var lineSpacing: CGFloat {
        switch self {
        case .large:
            return .spacingS
        default:
            return .spacingS
        }
    }

    var itemsPerRow: CGFloat {
        return 2
    }
    
    var columns: CGFloat {
        switch self {
        case .large: return 6
        default: return 4
        }
    }

    var itemHeight: CGFloat {
        return 72
    }
}
