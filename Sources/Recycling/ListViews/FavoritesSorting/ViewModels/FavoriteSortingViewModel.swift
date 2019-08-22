//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FavoriteSortingViewModel {
    public let lastAddedText: String
    public let statusText: String
    public let lastUpdatedText: String
    public let distanceText: String

    // MARK: - Init

    public init(
        lastAddedText: String,
        statusText: String,
        lastUpdatedText: String,
        distanceText: String
    ) {
        self.lastAddedText = lastAddedText
        self.statusText = statusText
        self.lastUpdatedText = lastUpdatedText
        self.distanceText = distanceText
    }

    // MARK: - Content

    func title(for option: FavoriteSortOption) -> String {
        switch option {
        case .lastAdded:
            return lastAddedText
        case .status:
            return statusText
        case .lastUpdated:
            return lastUpdatedText
        case .distance:
            return distanceText
        }
    }

    func icon(for option: FavoriteSortOption) -> UIImage? {
        switch option {
        case .lastAdded:
            return UIImage(named: .favoritesSortLastAdded)
        case .status:
            return UIImage(named: .favoritesSortAdStatus)
        case .lastUpdated:
            return UIImage(named: .republish)
        case .distance:
            return UIImage(named: .favoritesSortDistance)
        }
    }
}
