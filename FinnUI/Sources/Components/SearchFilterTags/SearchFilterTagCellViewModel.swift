//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct SearchFilterTagCellViewModel: Equatable {
    let title: String
    let titleAccessibilityLabel: String
    let removeButtonAccessibilityLabel: String
    let isValid: Bool

    public init(
        title: String,
        titleAccessibilityLabel: String,
        removeButtonAccessibilityLabel: String,
        isValid: Bool
    ) {
        self.title = title
        self.titleAccessibilityLabel = titleAccessibilityLabel
        self.removeButtonAccessibilityLabel = removeButtonAccessibilityLabel
        self.isValid = isValid
    }
}
