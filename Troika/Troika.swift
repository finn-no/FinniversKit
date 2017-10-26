//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

/// Class for referencing the framework bundle
public class Troika {

    static var bundle: Bundle {
        return Bundle(for: Troika.self)
    }
}

public extension Bundle {

    static var troika: Bundle {
        return Troika.bundle
    }
}
