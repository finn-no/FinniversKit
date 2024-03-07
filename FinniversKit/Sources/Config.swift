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
    public static var imageProvider: ImageProvider = DefaultImageProvider()
    public static var isDynamicTypeEnabled: Bool = true
}

public let warpColor = Warp.Config.colorProvider
public let warpUIColor = Warp.Config.uiColorProvider
public let warpToken = Warp.Config.tokenProvider
public let warpUIToken = Warp.Config.uiTokenProvider

@objc public extension Bundle {
    static var finniversKit: Bundle {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: BasicTableViewCell.self)
        #endif
    }
}
