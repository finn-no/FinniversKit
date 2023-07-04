//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ColorProvider {
    var bgPrimary: UIColor { get }
    var bgSecondary: UIColor { get }
    var bgTertiary: UIColor { get }
    var bgQuaternary: UIColor { get }
    var bgBottomSheet: UIColor { get }
    var bgAlert: UIColor { get }
    var bgInfo: UIColor { get }
    var bgSuccess: UIColor { get }
    var bgCritical: UIColor { get }
    var btnPrimary: UIColor { get }
    var btnDisabled: UIColor { get }
    var btnCritical: UIColor { get }
    var btnAction: UIColor { get }
    var textPrimary: UIColor { get }
    var textSecondary: UIColor { get }
    var textTertiary: UIColor { get }
    var textAction: UIColor { get }
    var textDisabled: UIColor { get }
    var textCritical: UIColor { get }
    var accentPrimaryBlue: UIColor { get }
    var accentSecondaryBlue: UIColor { get }
    var accentPea: UIColor { get }
    var accentToothpaste: UIColor { get }
    var textCTADisabled: UIColor { get }
    var textToast: UIColor { get }
    var tableViewSeparator: UIColor { get }
    var imageBorder: UIColor { get }
    var decorationSubtle: UIColor { get }
    var iconPrimary: UIColor { get }
    var iconSecondary: UIColor { get }
    var iconTertiary: UIColor { get }
    var borderDefault: UIColor { get }
}

// MARK: - Default FINN colors

public struct DefaultColorProvider: ColorProvider {
    public var bgPrimary: UIColor {
        .dynamicColor(defaultColor: .white, darkModeColor: .darkMilk)
    }

    public var bgSecondary: UIColor {
        .dynamicColor(defaultColor: .aqua50, darkModeColor: .darkIce)
    }

    public var bgTertiary: UIColor {
        .dynamicColor(defaultColor: .blueGray50, darkModeColor: .darkMarble)
    }

    public var bgQuaternary: UIColor {
        .dynamicColor(defaultColor: .blueGray50, darkModeColor: .darkMilk)
    }

    public var bgBottomSheet: UIColor {
        .dynamicColor(defaultColor: .white, darkModeColor: .darkIce)
    }

    public var bgAlert: UIColor {
        .yellow100
    }

    public var bgInfo: UIColor {
        .dynamicColor(defaultColor: .aqua50, darkModeColor: .darkIce)
    }

    public var bgSuccess: UIColor {
        .green100
    }

    public var bgCritical: UIColor {
        .red100
    }

    public var btnPrimary: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .darkCallToAction)
    }

    public var btnDisabled: UIColor {
        .dynamicColor(defaultColor: .blueGray300, darkModeColor: .darkSardine)
    }

    public var btnCritical: UIColor {
        .red600
    }

    public var btnAction: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .darkPrimaryBlue)
    }

    public var textPrimary: UIColor {
        .dynamicColor(defaultColor: .gray700, darkModeColor: .white)
    }

    public var textSecondary: UIColor {
        .dynamicColor(defaultColor: .gray500, darkModeColor: .darkStone)
    }

    public var textTertiary: UIColor {
        .white
    }

    public var textAction: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .darkPrimaryBlue)
    }

    public var textDisabled: UIColor {
        .dynamicColor(defaultColor: .blueGray300, darkModeColor: .darkSardine)
    }

    public var textCritical: UIColor {
        .dynamicColor(defaultColor: .red600, darkModeColor: .red400)
    }

    public var accentPrimaryBlue: UIColor {
        .blue600
    }

    public var accentSecondaryBlue: UIColor {
        .aqua400
    }

    public var accentPea: UIColor {
        .green400
    }

    public var accentToothpaste: UIColor {
        .aqua200
    }

    public var textCTADisabled: UIColor {
        .dynamicColor(defaultColor: .gray700, darkModeColor: .darkLicorice)
    }

    public var textToast: UIColor {
        .gray700
    }

    public var tableViewSeparator: UIColor {
        .borderDefault
    }

    public var imageBorder: UIColor {
        .borderDefault
    }

    public var decorationSubtle: UIColor {
        return .btnDisabled
    }

    public var iconPrimary: UIColor {
        return .textPrimary
    }

    public var iconSecondary: UIColor {
        return .textSecondary
    }

    public var iconTertiary: UIColor {
        return .textTertiary
    }

    public var borderDefault: UIColor {
        return .dynamicColor(defaultColor: .blueGray300, darkModeColor: .darkSardine)
    }
}
