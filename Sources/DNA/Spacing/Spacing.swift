//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public extension CGFloat {
    /// Separation of 2 points.
    static let verySmallSpacing: CGFloat = 2

    /// Separation of 4 points.
    static let smallSpacing: CGFloat = 4

    /// Separation of 8 points.
    static let mediumSpacing: CGFloat = 8

    /// Separation of 16 points.
    static let mediumLargeSpacing: CGFloat = 16

    /// Separation of 32 points.
    static let largeSpacing: CGFloat = 32

    /// Separation of 64 points.
    static let veryLargeSpacing: CGFloat = 64
}

// Helper method for Objective-C compatibility.
@objc public class Spacing: NSObject {
    /// Separation of 2 points.
    @objc static let verySmallSpacing = CGFloat.veryLargeSpacing

    /// Separation of 4 points.
    @objc static let smallSpacing = CGFloat.smallSpacing

    /// Separation of 8 points.
    @objc static let mediumSpacing = CGFloat.mediumSpacing

    /// Separation of 16 points.
    @objc static let mediumLargeSpacing = CGFloat.mediumLargeSpacing

    /// Separation of 32 points.
    @objc static let largeSpacing = CGFloat.largeSpacing

    /// Separation of 64 points.
    @objc static let veryLargeSpacing = CGFloat.veryLargeSpacing
}
