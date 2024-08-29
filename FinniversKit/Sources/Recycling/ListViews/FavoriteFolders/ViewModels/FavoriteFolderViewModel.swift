//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol FavoriteFolderViewModel: RemoteImageTableViewCellViewModel {
    var isSelected: Bool { get }
    var isDefault: Bool { get }
}

public extension FavoriteFolderViewModel {
    var accessibilityLabel: String {
        return title + (subtitle.map({ ". \($0)" }) ?? "")
    }
}
