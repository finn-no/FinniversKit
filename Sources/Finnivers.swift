//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

/// Class for referencing the framework bundle
public class Finnivers {
    static var bundle: Bundle {
        return Bundle(for: Finnivers.self)
    }
}

public extension Bundle {
    static var finnivers: Bundle {
        return Finnivers.bundle
    }
}
