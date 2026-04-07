import Foundation
import Warp
@_exported import UIKit

public struct Config {
    public static var bundle: Bundle { Bundle.finniversKit }
    public static var imageProvider: ImageProvider = DefaultImageProvider()
    public static var isDynamicTypeEnabled: Bool = true

    public static func accessibilityMultiplier() -> CGFloat {
        if Self.isDynamicTypeEnabled {
            switch UIScreen.main.traitCollection.preferredContentSizeCategory {
            case UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
                return 2.5
            case UIContentSizeCategory.accessibilityExtraExtraLarge:
                return 2.25
            case UIContentSizeCategory.accessibilityExtraLarge:
                return 2.0
            case UIContentSizeCategory.accessibilityLarge:
                return 1.75
            case UIContentSizeCategory.accessibilityMedium:
                return 1.5
            default:
                return 1.0
            }
        } else {
            return 1.0
        }
    }
}

@objc public extension Bundle {
    static var finniversKit: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BasicTableViewCell.self)
        #endif
    }
}
