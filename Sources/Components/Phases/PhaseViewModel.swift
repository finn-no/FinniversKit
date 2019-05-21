//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct PhaseViewModel {
    public let title: String
    public let detailText: String
    public let isHighlighted: Bool

    // MARK: - Init

    public init(title: String, detailText: String, isHighlighted: Bool) {
        self.title = title
        self.detailText = detailText
        self.isHighlighted = isHighlighted
    }
}
