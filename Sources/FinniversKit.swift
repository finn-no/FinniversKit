//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

/// Class for referencing the framework bundle
@objc public class FinniversKit: NSObject {
    static var bundle: Bundle {
        return Bundle(for: FinniversKit.self)
    }

    @objc public static var isDynamicTypeEnabled: Bool = true

    @objc public static var isDarkModeSupported: Bool = true
}

@objc public extension Bundle {
    static var finniversKit: Bundle {
        return FinniversKit.bundle
    }
}
