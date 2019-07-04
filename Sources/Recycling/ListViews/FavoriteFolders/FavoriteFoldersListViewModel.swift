//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol FavoriteFoldersListViewModel: RemoteImageTableViewCellViewModel {}

public extension FavoriteFoldersListViewModel {
    var accessibilityLabel: String {
        return title + (subtitle.map({ ". \($0)" }) ?? "")
    }
}
