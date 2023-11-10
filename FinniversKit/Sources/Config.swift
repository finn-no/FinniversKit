//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Warp
@_exported import UIKit

public struct Config {
    public static var bundle: Bundle { Bundle.finniversKit }
    public static var fontProvider: FontProvider = DefaultFontProvider()
    public static var colorProvider: ColorProvider = DefaultColorProvider()
    public static var warpTokenProvider = Warp.Config.tokenProvider
    public static var warpUITokenProvider = Warp.Config.uiTokenProvider
    public static var warpColorProvider = Warp.Config.colorProvider
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
