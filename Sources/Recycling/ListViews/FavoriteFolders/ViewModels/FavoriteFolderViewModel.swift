//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Bootstrap

public protocol FavoriteFolderViewModel: RemoteImageTableViewCellViewModel {
    var isSelected: Bool { get }
    var isDefault: Bool { get }
    var isXmas: Bool { get }
}

public extension FavoriteFolderViewModel {
    var accessibilityLabel: String {
        return title + (subtitle.map({ ". \($0)" }) ?? "")
    }
}
