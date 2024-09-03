//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Label {
    enum Style {
        case title1
        case title2
        case title3
        case bodyStrong
        case detailStrong
        case body
        case captionStrong
        case caption
        case detail

        public var font: UIFont {
            switch self {
            case .title1: return UIFont.title1
            case .title2: return UIFont.title2
            case .title3: return UIFont.title3
            case .bodyStrong: return UIFont.bodyStrong
            case .detailStrong: return UIFont.detailStrong
            case .body: return UIFont.body
            case .captionStrong: return UIFont.captionStrong
            case .caption: return UIFont.caption
            case .detail: return UIFont.detail
            }
        }

        var padding: UIEdgeInsets {
            return UIEdgeInsets(top: lineSpacing, left: 0, bottom: 0, right: 0)
        }

        var lineSpacing: CGFloat {
            switch self {
            case .title1, .title2, .title3:
                return font.pointSize * 0.5
            default:
                return 0
            }
        }
    }
}
