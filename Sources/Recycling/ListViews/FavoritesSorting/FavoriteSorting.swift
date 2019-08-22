//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public enum FavoriteSorting: Equatable, Hashable {
    case lastAdded
    case status
    case lastUpdated
    case distance

    var icon: UIImage? {
        switch self {
        case .lastAdded:
            return UIImage(named: .favoritesSortLastAdded)
        case .status:
            return UIImage(named: .favoritesSortAdStatus)
        case .lastUpdated:
            return UIImage(named: .republish)
        case .distance:
            return UIImage(named: .pin)
        }
    }
}
