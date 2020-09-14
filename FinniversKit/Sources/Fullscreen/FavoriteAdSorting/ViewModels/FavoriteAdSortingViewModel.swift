//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FavoriteAdSortingViewModel {
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
}
