//
//  Copyright © FINN.no AS. All rights reserved.
//

import Foundation

public struct StatisticsItemEmptyViewModel {
    public var title: String
    public var description: String
    public var accessibilityLabel: String

    public init(title: String, description: String) {
        self.title = title
        self.description = description
        self.accessibilityLabel = title + description
    }
}
