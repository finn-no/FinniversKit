//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Warp
@_exported import UIKit

public struct Config {
    public static var bundle: Bundle { Bundle.finniversKit }
    public static var imageProvider: ImageProvider = DefaultImageProvider()
    public static var isDynamicTypeEnabled: Bool = true
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
