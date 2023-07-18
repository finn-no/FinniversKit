//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension Label {
    enum Style {
        case title1
        case title2
        case title2Strong
        case title3
        case title3Strong
        case bodyStrong
        case detailStrong
        case bodyRegular
        case body
        case captionStrong
        case caption
        case detail

        @available(*, deprecated, message: "Use bodyStrong instead.")
        case title4
        @available(*, deprecated, message: "Use detailStrong instead.")
        case title5
        @available(*, deprecated, message: "Use captionStrong instead.")
        case captionHeavy

        public var font: UIFont {
            switch self {
            case .title1: return UIFont.title1
            case .title2: return UIFont.title2
            case .title2Strong: return UIFont.title2Strong
            case .title3: return UIFont.title3
            case .title3Strong: return UIFont.title3Strong
            case .bodyStrong, .title4: return UIFont.bodyStrong
            case .detailStrong, .title5: return UIFont.detailStrong
            case .bodyRegular: return UIFont.bodyRegular
            case .body: return UIFont.body
            case .captionStrong, .captionHeavy: return UIFont.captionStrong
            case .caption: return UIFont.caption
            case .detail: return UIFont.detail
            }
        }

        var padding: UIEdgeInsets {
            return UIEdgeInsets(top: lineSpacing, left: 0, bottom: 0, right: 0)
        }

        var lineSpacing: CGFloat {
            switch self {
            case .title1, .title2, .title2Strong, .title3, .title3Strong:
                return font.pointSize * 0.5
            default:
                return 0
            }
        }
    }
}
