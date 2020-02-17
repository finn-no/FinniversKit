//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public enum UserAdCellStyle {
    case `default`
    case compressed

    var imageSize: CGFloat {
        switch self {
        case .default: return 80
        case .compressed: return 50
        }
    }
}
