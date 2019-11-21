//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Bootstrap
import Foundation

/// Class for referencing the framework bundle
@objc public class FinniversKit: NSObject {
    public enum UserInterfaceStyleSupport {
        @available(iOS 13.0, *)
        case dynamic
        case forceLight
        case forceDark
    }

    public static var userInterfaceStyleSupport: UserInterfaceStyleSupport = .forceLight

    public static func setup(userInterfaceStyleSupport: UserInterfaceStyleSupport) {
        self.userInterfaceStyleSupport = userInterfaceStyleSupport
        Palette.current = .finnPalette
    }

    static var bundle: Bundle {
        return Bundle(for: FinniversKit.self)
    }
}

@objc public extension Bundle {
    static var finniversKit: Bundle {
        return FinniversKit.bundle
    }
}
