//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct SavedSearchSortingViewModel {
    public let lastChangedText: String
    public let lastCreatedText: String
    public let alphabeticalText: String

    // MARK: - Init

    public init(
        lastChangedText: String,
        lastCreatedText: String,
        alphabeticalText: String
    ) {
        self.lastChangedText = lastChangedText
        self.lastCreatedText = lastCreatedText
        self.alphabeticalText = alphabeticalText
    }
}
