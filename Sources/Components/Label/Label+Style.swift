//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Label {
    public enum Style {
        case title1
        case title2
        case title3
        case title4
        case title5
        case body
        case captionHeavy
        case caption
        case detail

        var font: UIFont {
            switch self {
            case .title1: return UIFont.title1
            case .title2: return UIFont.title2
            case .title3: return UIFont.title3
            case .title4: return UIFont.title4
            case .title5: return UIFont.title5
            case .body: return UIFont.body
            case .captionHeavy: return UIFont.captionHeavy
            case .caption: return UIFont.caption
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
