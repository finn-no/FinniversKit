//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

/// Class for referencing the framework bundle
public class Munch {
    static var bundle: Bundle {
        return Bundle(for: Munch.self)
    }
}

public extension Bundle {
    static var munch: Bundle {
        return Munch.bundle
    }
}
