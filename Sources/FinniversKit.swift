//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Bootstrap
import Foundation

/// Class for referencing the framework bundle
@objc public class FinniversKit: NSObject {
    static var bundle: Bundle {
        return Bundle(for: FinniversKit.self)
    }
}

@objc public extension Bundle {
    static var finniversKit: Bundle {
        return FinniversKit.bundle
    }
}
