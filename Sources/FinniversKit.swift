//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

/// Class for referencing the framework bundle
public class FinniversKit {
    static var bundle: Bundle {
        return Bundle(for: FinniversKit.self)
    }

    public static var isDynamicTypeEnabled: Bool = true
}

public extension Bundle {
    static var finniversKit: Bundle {
        return FinniversKit.bundle
    }
}
