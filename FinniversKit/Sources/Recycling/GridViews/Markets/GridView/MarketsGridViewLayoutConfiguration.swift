//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

enum MarketsGridViewLayoutConfiguration {
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
        .spacingS
    }

    var sideMargins: CGFloat {
        .spacingM
    }

    var edgeInsets: UIEdgeInsets {
        UIEdgeInsets(top: 0,
                     left: sideMargins,
                     bottom: 0,
                     right: sideMargins)
    }

    var lineSpacing: CGFloat {
        .spacingS
    }

    var itemsPerRow: CGFloat {
        2
    }

    var columns: CGFloat {
        switch self {
        case .large: return 6
        default: return 4
        }
    }

    var itemHeight: CGFloat {
        72
    }
}
