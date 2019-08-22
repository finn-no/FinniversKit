//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public enum FavoriteFolderAction: Equatable, Hashable, CaseIterable {
    case edit
    case changeName
    case share
    case copyLink
    case delete

    static func cases(withCopyLink: Bool) -> [FavoriteFolderAction] {
        return withCopyLink ? allCases : allCases.filter({ $0 != .copyLink })
    }
}
