//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

/// Class for referencing the framework bundle
public class TroikaDemoKit {

    static var bundle: Bundle {
        return Bundle(for: TroikaDemoKit.self)
    }

    public static func setupPlayground() {
        UIFont.registerTroikaFonts()
    }
}

public extension Bundle {

    static var troikaDemoKit: Bundle {
        return TroikaDemoKit.bundle
    }
}
