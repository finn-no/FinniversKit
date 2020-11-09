//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
@_exported import UIKit

public enum UserInterfaceStyleSupport {
    @available(iOS 13.0, *)
    case dynamic
    case forceLight
    case forceDark
}

public struct Config {
    public static var bundle: Bundle { Bundle.finniversKit }
    public static var fontProvider: FontProvider = DefaultFontProvider()
    public static var colorProvider: ColorProvider = DefaultColorProvider()
    public static var isDynamicTypeEnabled: Bool = true
    public static var userInterfaceStyleSupport: UserInterfaceStyleSupport = {
        if #available(iOS 13.0, *) {
            return .dynamic
        } else {
            return .forceLight
        }
    }()
}

@objc public extension Bundle {
    static var finniversKit: Bundle {
        Bundle(for: BasicTableViewCell.self)
    }
}
