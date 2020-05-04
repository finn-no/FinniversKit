//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

/// Class for referencing the framework bundle
@objc public class FinniversKit: NSObject {
    public enum UserInterfaceStyleSupport {
        @available(iOS 13.0, *)
        case dynamic
        case forceLight
        case forceDark
    }

    static var bundle: Bundle {
        return Bundle(for: FinniversKit.self)
    }

    public static var isDynamicTypeEnabled: Bool = true
    public static var userInterfaceStyleSupport: UserInterfaceStyleSupport = {
        if #available(iOS 13.0, *) {
            return .dynamic
        } else {
            return .forceLight
        }
    }()
}

@objc public extension Bundle {
    static var finniversKit: Bundle {
        return FinniversKit.bundle
    }
}
