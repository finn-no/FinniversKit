//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ColorProvider {
    @available(*, deprecated, message: "Use Warp background instead")
    var bgPrimary: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    var bgSecondary: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    var bgTertiary: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    var bgQuaternary: UIColor { get }
    @available(*, deprecated, message: "Use Warp background instead")
    var bgBottomSheet: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundWarningSubtle instead")
    var bgAlert: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    var bgInfo: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var bgWarningSubtle: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var bgNegativeSubtle: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var bgInfoSubtle: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var bgPositiveSubtle: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var bgInfoHeader: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundPositiveSubtle instead")
    var bgSuccess: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundNegativeSubtle instead")
    var bgCritical: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var bgCallout: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderInfo: UIColor { get }
//    @available(*, deprecated, message: "Use Warp color instead")
//    var borderNegative: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderPositive: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderWarning: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderCallout: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderInfoSubtle: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderNegativeSubtle: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderPositiveSubtle: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderWarningSubtle: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var borderSecondary: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    var btnPrimary: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    var btnDisabled: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundNegative instead")
    var btnCritical: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    var btnAction: UIColor { get }
    @available(*, deprecated, message: "Use Warp text instead")
    var textPrimary: UIColor { get }
    @available(*, deprecated, message: "Use Warp textSubtle instead")
    var textSecondary: UIColor { get }
    @available(*, deprecated, message: "Use Warp textInverted instead")
    var textTertiary: UIColor { get }
    @available(*, deprecated, message: "Use Warp textLink instead")
    var textAction: UIColor { get }
    @available(*, deprecated, message: "Use Warp textDisabled instead")
    var textDisabled: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var textAlert: UIColor { get }
    @available(*, deprecated, message: "Use Warp textNegative instead")
    var textCritical: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var accentPrimaryBlue: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var accentSecondaryBlue: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var accentPea: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var accentToothpaste: UIColor { get }
    @available(*, deprecated, message: "Use Warp text instead")
    var textCTADisabled: UIColor { get }
    @available(*, deprecated, message: "Use Warp text instead")
    var textToast: UIColor { get }
    @available(*, deprecated, message: "Use Warp border instead")
    var tableViewSeparator: UIColor { get }
    @available(*, deprecated, message: "Use Warp border instead")
    var imageBorder: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    var decorationSubtle: UIColor { get }
//    var iconPrimary: UIColor { get }
//    @available(*, deprecated, message: "Use Warp icon instead")
//    var iconSecondary: UIColor { get }
    @available(*, deprecated, message: "Use Warp iconInverted instead")
    var iconTertiary: UIColor { get }
    @available(*, deprecated, message: "Use Warp border instead")
    var borderDefault: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var marketplaceNavigationBarIcon: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var nmpBrandTabBarIconSelected: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var nmpBrandColorPrimary: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var nmpBrandColorSecondary: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    var nmpBrandControlSelected: UIColor { get }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    var nmpBrandDecoration: UIColor { get }
    @available(*, deprecated, message: "Use Warp color instead")
    var loadingIndicator: UIColor { get }
}

// MARK: - Default FINN colors

public struct DefaultColorProvider: ColorProvider {

    public static let shared = DefaultColorProvider()

    @available(*, deprecated, message: "Use Warp background instead")
    public var bgPrimary: UIColor {
        .dynamicColor(defaultColor: .white, darkModeColor: .darkMilk)
    }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    public var bgSecondary: UIColor {
        .dynamicColor(defaultColor: .aqua50, darkModeColor: .darkIce)
    }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    public var bgTertiary: UIColor {
        .dynamicColor(defaultColor: .blueGray50, darkModeColor: .darkMarble)
    }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    public var bgQuaternary: UIColor {
        .dynamicColor(defaultColor: .blueGray50, darkModeColor: .darkMilk)
    }
    @available(*, deprecated, message: "Use Warp background instead")
    public var bgBottomSheet: UIColor {
        .dynamicColor(defaultColor: .white, darkModeColor: .darkIce)
    }
    @available(*, deprecated, message: "Use Warp backgroundWarningSubtle instead")
    public var bgAlert: UIColor {
        .yellow100
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var bgCallout: UIColor {
        .green100
    }

    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    public var bgInfo: UIColor {
        .dynamicColor(defaultColor: .aqua50, darkModeColor: .darkIce)
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var bgInfoHeader: UIColor {
        .dynamicColor(defaultColor: .aqua200, darkModeColor: .blue600)
    }
    @available(*, deprecated, message: "Use Warp backgroundPositiveSubtle instead")
    public var bgSuccess: UIColor {
        .green100
    }
    @available(*, deprecated, message: "Use Warp backgroundNegativeSubtle instead")
    public var bgCritical: UIColor {
        .red100
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var bgInfoSubtle: UIColor {
        .dynamicColor(defaultColor: .aqua50, darkModeColor: .aqua900)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var bgNegativeSubtle: UIColor {
        .dynamicColor(defaultColor: .red50, darkModeColor: .red900)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var bgPositiveSubtle: UIColor {
        .dynamicColor(defaultColor: .green50, darkModeColor: .green900)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var bgWarningSubtle: UIColor {
        .dynamicColor(defaultColor: .yellow50, darkModeColor: .yellow900)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderInfo: UIColor {
        .dynamicColor(defaultColor: .aqua600, darkModeColor: .aqua500)
    }

//    @available(*, deprecated, message: "Use Warp color instead")
//    public var borderNegative: UIColor {
//        .dynamicColor(defaultColor: .red600, darkModeColor: .red500)
//    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderPositive: UIColor {
        .dynamicColor(defaultColor: .green600, darkModeColor: .green500)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderWarning: UIColor {
        .dynamicColor(defaultColor: .yellow600, darkModeColor: .yellow500)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderCallout: UIColor {
        .accentPea
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderInfoSubtle: UIColor {
        .dynamicColor(defaultColor: .aqua300, darkModeColor: .aqua700)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderNegativeSubtle: UIColor {
        .dynamicColor(defaultColor: .red300, darkModeColor: .red700)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderPositiveSubtle: UIColor {
        .dynamicColor(defaultColor: .green300, darkModeColor: .green700)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderWarningSubtle: UIColor {
        .dynamicColor(defaultColor: .yellow300, darkModeColor: .yellow700)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var borderSecondary: UIColor {
        .aqua400
    }

    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public var btnPrimary: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .blue500)
    }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    public var btnDisabled: UIColor {
        .dynamicColor(defaultColor: .blueGray300, darkModeColor: .darkSardine)
    }
    @available(*, deprecated, message: "Use Warp backgroundNegative instead")
    public var btnCritical: UIColor {
        .red600
    }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public var btnAction: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .blue500)
    }
    @available(*, deprecated, message: "Use Warp text instead")
    public var textPrimary: UIColor {
        .dynamicColor(defaultColor: .gray700, darkModeColor: .white)
    }
    @available(*, deprecated, message: "Use Warp textSubtle instead")
    public var textSecondary: UIColor {
        .dynamicColor(defaultColor: .gray500, darkModeColor: .darkStone)
    }
    @available(*, deprecated, message: "Use Warp textInverted instead")
    public var textTertiary: UIColor {
        .white
    }
    @available(*, deprecated, message: "Use Warp textLink instead")
    public var textAction: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .blue500)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var textDisabled: UIColor {
        .dynamicColor(defaultColor: .blueGray300, darkModeColor: .darkSardine)
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var textAlert: UIColor {
        .lightNuttyBrown
    }

    @available(*, deprecated, message: "Use Warp textNegative instead")
    public var textCritical: UIColor {
        .dynamicColor( defaultColor: .red600, darkModeColor: .red400)
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var accentPrimaryBlue: UIColor {
        .blue600
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var accentSecondaryBlue: UIColor {
        .aqua400
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var accentPea: UIColor {
        .green400
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var accentToothpaste: UIColor {
        .aqua200
    }
    @available(*, deprecated, message: "Use Warp text instead")
    public var textCTADisabled: UIColor {
        .dynamicColor(defaultColor: .gray700, darkModeColor: .darkLicorice)
    }
    @available(*, deprecated, message: "Use Warp text instead")
    public var textToast: UIColor {
        .gray700
    }
    @available(*, deprecated, message: "Use Warp border instead")
    public var tableViewSeparator: UIColor {
        .borderDefault
    }
    @available(*, deprecated, message: "Use Warp border instead")
    public var imageBorder: UIColor {
        .borderDefault
    }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    public var decorationSubtle: UIColor {
        .backgroundDisabled
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var iconPrimary: UIColor {
        .text
    }
//    @available(*, deprecated, message: "Use Warp icon instead")
//    public var iconSecondary: UIColor {
//        .textSubtle
//    }
    @available(*, deprecated, message: "Use Warp iconInverted instead")
    public var iconTertiary: UIColor {
        .textInverted
    }
    @available(*, deprecated, message: "Use Warp border instead")
    public var borderDefault: UIColor {
        .dynamicColor(defaultColor: .blueGray300, darkModeColor: .darkSardine)
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var marketplaceNavigationBarIcon: UIColor {
        .aqua400
    }

    // NMP brand colors
    @available(*, deprecated, message: "Use Warp color instead")
    public var nmpBrandTabBarIconSelected: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .blue500)
    }

    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public var nmpBrandControlSelected: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .blue500)
    }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public var nmpBrandDecoration: UIColor {
        .dynamicColor(defaultColor: .blue600, darkModeColor: .blue500)
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var nmpBrandColorPrimary: UIColor {
        .blue600
    }
    @available(*, deprecated, message: "Use Warp color instead")
    public var nmpBrandColorSecondary: UIColor {
        .aqua400
    }

    @available(*, deprecated, message: "Use Warp color instead")
    public var loadingIndicator: UIColor {
        .aqua400
    }
}
