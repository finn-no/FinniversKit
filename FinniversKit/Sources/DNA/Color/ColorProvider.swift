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
    var bgWarningSubtle: UIColor { get }
    var bgNegativeSubtle: UIColor { get }
    var bgInfoSubtle: UIColor { get }
    var bgPositiveSubtle: UIColor { get }
    var bgInfoHeader: UIColor { get }
    var bgSuccess: UIColor { get }
    var bgCritical: UIColor { get }
    var borderInfo: UIColor { get }
    var borderNegative: UIColor { get }
    var borderPositive: UIColor { get }
    var borderWarning: UIColor { get }
    var borderInfoSubtle: UIColor { get }
    var borderNegativeSubtle: UIColor { get }
    var borderPositiveSubtle: UIColor { get }
    var borderWarningSubtle: UIColor { get }
    var btnPrimary: UIColor { get }
    var btnDisabled: UIColor { get }
    var btnCritical: UIColor { get }
    var btnAction: UIColor { get }
    var textPrimary: UIColor { get }
    var textSecondary: UIColor { get }
    var textTertiary: UIColor { get }
    var textAction: UIColor { get }
    var textDisabled: UIColor { get }
    var textAlert: UIColor { get }
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
    var marketplaceNavigationBarIcon: UIColor { get }
    var nmpBrandTabBarIconSelected: UIColor { get }
    var nmpBrandColorPrimary: UIColor { get }
    var nmpBrandColorSecondary: UIColor { get }
    var nmpBrandControlSelected: UIColor { get }
    var nmpBrandDecoration: UIColor { get }
    var loadingIndicator: UIColor { get }
}

// MARK: - Default FINN colors

public struct DefaultColorProvider: ColorProvider {

    public static let shared = DefaultColorProvider()

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

    public var bgInfoHeader: UIColor {
        .dynamicColor(defaultColor: .aqua200, darkModeColor: .blue600)
    }

    public var bgSuccess: UIColor {
        .green100
    }

    public var bgCritical: UIColor {
        .red100
    }

    public var bgInfoSubtle: UIColor {
        .dynamicColor(defaultColor: .aqua50, darkModeColor: .aqua900)
    }

    public var bgNegativeSubtle: UIColor {
        .dynamicColor(defaultColor: .red50, darkModeColor: .red900)
    }

    public var bgPositiveSubtle: UIColor {
        .dynamicColor(defaultColor: .green50, darkModeColor: .green900)
    }

    public var bgWarningSubtle: UIColor {
        .dynamicColor(defaultColor: .yellow50, darkModeColor: .yellow900)
    }

    public var borderInfo: UIColor {
        .dynamicColor(defaultColor: .aqua600, darkModeColor: .aqua500)
    }

    public var borderNegative: UIColor {
        .dynamicColor(defaultColor: .red600, darkModeColor: .red500)
    }

    public var borderPositive: UIColor {
        .dynamicColor(defaultColor: .green600, darkModeColor: .green500)
    }

    public var borderWarning: UIColor {
        .dynamicColor(defaultColor: .yellow600, darkModeColor: .yellow500)
    }

    public var borderInfoSubtle: UIColor {
        .dynamicColor(defaultColor: .aqua300, darkModeColor: .aqua700)
    }

    public var borderNegativeSubtle: UIColor {
        .dynamicColor(defaultColor: .red300, darkModeColor: .red700)
    }

    public var borderPositiveSubtle: UIColor {
        .dynamicColor(defaultColor: .green300, darkModeColor: .green700)
    }

    public var borderWarningSubtle: UIColor {
        .dynamicColor(defaultColor: .yellow300, darkModeColor: .yellow700)
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

    public var textAlert: UIColor {
        .lightNuttyBrown
    }

    public var textCritical: UIColor {
        .dynamicColor( defaultColor: .red600, darkModeColor: .red400)
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
        .btnDisabled
    }

    public var iconPrimary: UIColor {
        .textPrimary
    }

    public var iconSecondary: UIColor {
        .textSecondary
    }

    public var iconTertiary: UIColor {
        .textTertiary
    }

    public var borderDefault: UIColor {
        .dynamicColor(defaultColor: .blueGray300, darkModeColor: .darkSardine)
    }

    public var marketplaceNavigationBarIcon: UIColor {
        .aqua400
    }

    // NMP brand colors
    public var nmpBrandTabBarIconSelected: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .darkCallToAction)
    }

    public var nmpBrandControlSelected: UIColor {
        .blue600
    }

    public var nmpBrandDecoration: UIColor {
        .blue600
    }

    public var nmpBrandColorPrimary: UIColor {
        .blue600
    }

    public var nmpBrandColorSecondary: UIColor {
        .aqua400
    }

    public var loadingIndicator: UIColor {
        .aqua400
    }
}
