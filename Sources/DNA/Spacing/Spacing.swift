//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension CGFloat {
    /// Separation of 2 points.
    @available(*, deprecated, message: "Use spacingXXS instead.")
    static let verySmallSpacing = Spacing.verySmallSpacing()

    /// Separation of 4 points.
    @available(*, deprecated, message: "Use spacingXS instead.")
    static let smallSpacing = Spacing.smallSpacing()

    /// Separation of 8 points.
    @available(*, deprecated, message: "Use spacingS instead.")
    static let mediumSpacing = Spacing.mediumSpacing()

    /// Separation of 16 points.
    @available(*, deprecated, message: "Use spacingM instead.")
    static let mediumLargeSpacing = Spacing.mediumLargeSpacing()

    /// Separation of 24 points.
    @available(*, deprecated, message: "Use spacingL instead.")
    static let mediumPlusSpacing = Spacing.mediumPlusSpacing()

    /// Separation of 32 points.
    @available(*, deprecated, message: "Use spacingXL instead.")
    static let largeSpacing = Spacing.largeSpacing()

    /// Separation of 64 points.
    @available(*, deprecated, message: "Use spacingXXL instead.")
    static let veryLargeSpacing = Spacing.veryLargeSpacing()

    /// Separation of 2 points.
    static let spacingXXS = Spacing.spacingXXS()

    /// Separation of 4 points.
    static let spacingXS = Spacing.spacingXS()

    /// Separation of 8 points.
    static let spacingS = Spacing.spacingS()

    /// Separation of 16 points.
    static let spacingM = Spacing.spacingM()

    /// Separation of 24 points.
    static let spacingL = Spacing.spacingL()

    /// Separation of 32 points.
    static let spacingXL = Spacing.spacingXL()

    /// Separation of 64 points.
    static let spacingXXL = Spacing.spacingXXL()
}
