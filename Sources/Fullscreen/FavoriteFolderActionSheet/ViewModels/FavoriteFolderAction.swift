//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public enum FavoriteFolderAction: Equatable, Hashable, CaseIterable {
    case edit
    case rename
    case toggleSharing
    case shareLink
    case delete

    static func cases(withShareLink: Bool) -> [FavoriteFolderAction] {
        return withShareLink ? allCases : allCases.filter({ $0 != .shareLink })
    }
}
