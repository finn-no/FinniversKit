//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public enum FavoriteActionViewModel: Equatable, Hashable {
    case edit(title: String)
    case changeName(title: String)
    case share(title: String, selected: Bool)
    case copyLink(title: String, buttonTitle: String)
    case delete(title: String)

    var icon: UIImage? {
        switch self {
        case .edit:
            return UIImage(named: .favoritesEdit)
        case .changeName:
            return UIImage(named: .pencilPaper)
        case .share:
            return UIImage(named: .share)
        case .copyLink:
            return UIImage(named: .share)
        case .delete:
            return UIImage(named: .trashcan)
        }
    }
}
