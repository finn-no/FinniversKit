//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol FavoriteFolderViewModel: RemoteImageTableViewCellViewModel {}

public extension FavoriteFolderViewModel {
    var accessibilityLabel: String {
        return title + (subtitle.map({ ". \($0)" }) ?? "")
    }
}
