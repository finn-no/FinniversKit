//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import SwiftUI

// MARK: - Warp colors
extension Color {
    public static var background: Color { Config.warpTokenProvider.background }
    public static var backgroundInfoSubtle: Color { Config.warpTokenProvider.backgroundInfoSubtle }
    public static var backgroundSubtle: Color { Config.warpTokenProvider.backgroundSubtle }
    public static var backgroundWarningSubtle: Color { Config.warpTokenProvider.backgroundWarningSubtle }
    public static var backgroundPositiveSubtle: Color { Config.warpTokenProvider.backgroundPositiveSubtle }
    public static var backgroundNegativeSubtle: Color { Config.warpTokenProvider.backgroundNegativeSubtle }
    public static var backgroundPrimary: Color { Config.warpTokenProvider.backgroundPrimary }
    public static var backgroundDisabled: Color { Config.warpTokenProvider.backgroundDisabled }
    public static var backgroundNegative: Color { Config.warpTokenProvider.backgroundNegative }
    public static var text: Color { Config.warpTokenProvider.text }
    public static var textSubtle: Color { Config.warpTokenProvider.textSubtle }
    public static var textInverted: Color { Config.warpTokenProvider.textInverted }
    public static var textLink: Color { Config.warpTokenProvider.textLink }
    public static var textDisabled: Color { Config.warpTokenProvider.textDisabled }
    public static var textNegative: Color { Config.warpTokenProvider.textNegative }
    public static var border: Color { Config.warpTokenProvider.border }
    public static var iconPrimary: Color { Config.warpTokenProvider.iconPrimary }
    public static var iconInverted: Color { Config.warpTokenProvider.iconInverted }
}

@objc extension UIColor {
    public static var background: UIColor { UIColor(.background) }
    public static var backgroundInfoSubtle: UIColor { UIColor(.backgroundInfoSubtle) }
    public static var backgroundSubtle: UIColor { UIColor(.backgroundSubtle) }
    public static var backgroundWarningSubtle: UIColor { UIColor(.backgroundWarningSubtle) }
    public static var backgroundPositiveSubtle: UIColor { UIColor(.backgroundPositiveSubtle) }
    public static var backgroundNegativeSubtle: UIColor { UIColor(.backgroundNegativeSubtle) }
    public static var backgroundPrimary: UIColor { UIColor(.backgroundPrimary) }
    public static var backgroundDisabled: UIColor { UIColor(.backgroundDisabled) }
    public static var backgroundNegative: UIColor { UIColor(.backgroundNegative) }
    public static var text: UIColor { UIColor(.text) }
    public static var textSubtle: UIColor { UIColor(.textSubtle) }
    public static var textInverted: UIColor { UIColor(.textInverted) }
    public static var textLink: UIColor { UIColor(.textLink) }
    public static var textDisabled: UIColor { UIColor(.textDisabled) }
    public static var textNegative: UIColor { UIColor(.textNegative) }
    public static var border: UIColor { UIColor(.border) }
    public static var iconPrimary: UIColor { UIColor(.iconPrimary) }
    public static var iconInverted: UIColor { UIColor(.iconInverted) }
}

extension CGColor {
    public class var background: CGColor { UIColor.background.cgColor }
    public class var backgroundInfoSubtle: CGColor { UIColor.backgroundInfoSubtle.cgColor }
    public class var backgroundSubtle: CGColor { UIColor.backgroundSubtle.cgColor }
    public class var backgroundWarningSubtle: CGColor { UIColor.backgroundWarningSubtle.cgColor }
    public class var backgroundPositiveSubtle: CGColor { UIColor.backgroundPositiveSubtle.cgColor }
    public class var backgroundNegativeSubtle: CGColor { UIColor.backgroundNegativeSubtle.cgColor }
    public class var backgroundPrimary: CGColor { UIColor.backgroundPrimary.cgColor }
    public class var backgroundDisabled: CGColor { UIColor.backgroundDisabled.cgColor }
    public class var backgroundNegative: CGColor { UIColor.backgroundNegative.cgColor }
    public class var text: CGColor { UIColor.text.cgColor }
    public class var textSubtle: CGColor { UIColor.textSubtle.cgColor }
    public class var textInverted: CGColor { UIColor.textInverted.cgColor }
    public class var textLink: CGColor { UIColor.textLink.cgColor }
    public class var textDisabled: CGColor { UIColor.textDisabled.cgColor }
    public class var textNegative: CGColor { UIColor.textNegative.cgColor }
    public class var border: CGColor { UIColor.border.cgColor }
    public class var iconPrimary: CGColor { UIColor.iconPrimary.cgColor }
    public class var iconInverted: CGColor { UIColor.iconInverted.cgColor }
}

// MARK: - Semantic colors, dark mode compatible
@objc extension UIColor {
    @available(*, deprecated, message: "Use Warp color instead")
    public class var accentPea: UIColor { Config.colorProvider.accentPea }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var accentPrimaryBlue: UIColor { Config.colorProvider.accentPrimaryBlue }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var accentSecondaryBlue: UIColor { Config.colorProvider.accentSecondaryBlue }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var accentToothpaste: UIColor { Config.colorProvider.accentToothpaste }
    @available(*, deprecated, message: "Use Warp backgroundWarningSubtle instead")
    public class var bgAlert: UIColor { Config.colorProvider.bgAlert }
    @available(*, deprecated, message: "Use Warp background instead")
    public class var bgBottomSheet: UIColor { Config.colorProvider.bgBottomSheet }
    @available(*, deprecated, message: "Use Warp backgroundNegativeSubtle instead")
    public class var bgCritical: UIColor { Config.colorProvider.bgCritical }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    public class var bgInfo: UIColor { Config.colorProvider.bgInfo }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var bgInfoHeader: UIColor { Config.colorProvider.bgInfoHeader }
    @available(*, deprecated, message: "Use Warp background instead")
    public class var bgPrimary: UIColor { Config.colorProvider.bgPrimary }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    public class var bgQuaternary: UIColor { Config.colorProvider.bgQuaternary }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    public class var bgSecondary: UIColor { Config.colorProvider.bgSecondary }
    @available(*, deprecated, message: "Use Warp backgroundPositiveSubtle instead")
    public class var bgSuccess: UIColor { Config.colorProvider.bgSuccess }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    public class var bgTertiary: UIColor { Config.colorProvider.bgTertiary }
    @available(*, deprecated, message: "Use Warp border instead")
    public class var borderDefault: UIColor { Config.colorProvider.borderDefault }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public class var btnAction: UIColor { Config.colorProvider.btnAction }
    @available(*, deprecated, message: "Use Warp backgroundNegative instead")
    public class var btnCritical: UIColor { Config.colorProvider.btnCritical }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    public class var btnDisabled: UIColor { Config.colorProvider.btnDisabled }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public class var btnPrimary: UIColor { Config.colorProvider.btnPrimary }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    public class var decorationSubtle: UIColor { Config.colorProvider.decorationSubtle }
//    public class var iconPrimary: UIColor { Config.colorProvider.iconPrimary }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var iconSecondary: UIColor { Config.colorProvider.iconSecondary }
    @available(*, deprecated, message: "Use Warp iconInverted instead")
    public class var iconTertiary: UIColor { Config.colorProvider.iconTertiary }
    @available(*, deprecated, message: "Use Warp border instead")
    public class var imageBorder: UIColor { Config.colorProvider.imageBorder }
    @available(*, deprecated, message: "Use Warp border instead")
    public class var tableViewSeparator: UIColor { Config.colorProvider.tableViewSeparator }
    @available(*, deprecated, message: "Use Warp textLink instead")
    public class var textAction: UIColor { Config.colorProvider.textAction }
    @available(*, deprecated, message: "Use Warp textNegative instead")
    public class var textCritical: UIColor { Config.colorProvider.textCritical }
    @available(*, deprecated, message: "Use Warp text instead")
    public class var textCTADisabled: UIColor { Config.colorProvider.textCTADisabled }
//    public class var textDisabled: UIColor { Config.colorProvider.textDisabled }
    @available(*, deprecated, message: "Use Warp text instead")
    public class var textPrimary: UIColor { Config.colorProvider.textPrimary }
    @available(*, deprecated, message: "Use Warp textSubtle instead")
    public class var textSecondary: UIColor { Config.colorProvider.textSecondary }
    @available(*, deprecated, message: "Use Warp textInverted instead")
    public class var textTertiary: UIColor { Config.colorProvider.textTertiary }
    @available(*, deprecated, message: "Use Warp text instead")
    public class var textToast: UIColor { Config.colorProvider.textToast }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var marketplaceNavigationBarIcon: UIColor { Config.colorProvider.marketplaceNavigationBarIcon }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var nmpBrandColorPrimary: UIColor { Config.colorProvider.nmpBrandColorPrimary }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var nmpBrandColorSecondary: UIColor { Config.colorProvider.nmpBrandColorSecondary }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var nmpBrandControlSelected: UIColor { Config.colorProvider.nmpBrandControlSelected }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var nmpBrandDecoration: UIColor { Config.colorProvider.nmpBrandDecoration }
}

extension CGColor {
    @available(*, deprecated, message: "Use Warp color instead")
    public class var accentPea: CGColor { UIColor.accentPea.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var accentPrimaryBlue: CGColor { UIColor.accentPrimaryBlue.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var accentSecondaryBlue: CGColor { UIColor.accentSecondaryBlue.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var accentToothpaste: CGColor { UIColor.accentToothpaste.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundWarningSubtle instead")
    public class var bgAlert: CGColor { UIColor.bgAlert.cgColor }
    @available(*, deprecated, message: "Use Warp background instead")
    public class var bgBottomSheet: CGColor { UIColor.bgBottomSheet.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundNegativeSubtle instead")
    public class var bgCritical: CGColor { UIColor.bgCritical.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    public class var bgInfo: CGColor { UIColor.bgInfo.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var bgInfoHeader: CGColor { UIColor.bgInfoHeader.cgColor }
    @available(*, deprecated, message: "Use Warp background instead")
    public class var bgPrimary: CGColor { UIColor.bgPrimary.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    public class var bgQuaternary: CGColor { UIColor.bgQuaternary.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    public class var bgSecondary: CGColor { UIColor.bgSecondary.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundPositiveSubtle instead")
    public class var bgSuccess: CGColor { UIColor.bgSuccess.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    public class var bgTertiary: CGColor { UIColor.bgTertiary.cgColor }
    @available(*, deprecated, message: "Use Warp border instead")
    public class var borderDefault: CGColor { UIColor.borderDefault.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public class var btnAction: CGColor { UIColor.btnAction.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundNegative instead")
    public class var btnCritical: CGColor { UIColor.btnCritical.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    public class var btnDisabled: CGColor { UIColor.btnDisabled.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public class var btnPrimary: CGColor { UIColor.btnPrimary.cgColor }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    public class var decorationSubtle: CGColor { UIColor.decorationSubtle.cgColor }
//    public class var iconPrimary: CGColor { UIColor.iconPrimary.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var iconSecondary: CGColor { UIColor.iconSecondary.cgColor }
    @available(*, deprecated, message: "Use Warp iconInverted instead")
    public class var iconTertiary: CGColor { UIColor.iconTertiary.cgColor }
    @available(*, deprecated, message: "Use Warp border instead")
    public class var imageBorder: CGColor { UIColor.imageBorder.cgColor }
    @available(*, deprecated, message: "Use Warp border instead")
    public class var tableViewSeparator: CGColor { UIColor.tableViewSeparator.cgColor }
    @available(*, deprecated, message: "Use Warp textLink instead")
    public class var textAction: CGColor { UIColor.textAction.cgColor }
    @available(*, deprecated, message: "Use Warp textNegative instead")
    public class var textCritical: CGColor { UIColor.textCritical.cgColor }
    @available(*, deprecated, message: "Use Warp text instead")
    public class var textCTADisabled: CGColor { UIColor.textCTADisabled.cgColor }
//    public class var textDisabled: CGColor { UIColor.textDisabled.cgColor }
    @available(*, deprecated, message: "Use Warp text instead")
    public class var textPrimary: CGColor { UIColor.textPrimary.cgColor }
    @available(*, deprecated, message: "Use Warp textSubtle instead")
    public class var textSecondary: CGColor { UIColor.textSecondary.cgColor }
    @available(*, deprecated, message: "Use Warp textInverted instead")
    public class var textTertiary: CGColor { UIColor.textTertiary.cgColor }
    @available(*, deprecated, message: "Use Warp text instead")
    public class var textToast: CGColor { UIColor.textToast.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var marketplaceNavigationBarIcon: CGColor { Config.colorProvider.marketplaceNavigationBarIcon.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var nmpBrandColorPrimary: CGColor { Config.colorProvider.nmpBrandColorPrimary.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var nmpBrandColorSecondary: CGColor { Config.colorProvider.nmpBrandColorSecondary.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var nmpBrandControlSelected: CGColor { Config.colorProvider.nmpBrandControlSelected.cgColor }
    @available(*, deprecated, message: "Use Warp color instead")
    public class var nmpBrandDecoration: CGColor { Config.colorProvider.nmpBrandDecoration.cgColor }
}

// MARK: - FINN UIColors (deprecated)
@available(*, deprecated, message: "Use Fabric colors instead")
@objc extension UIColor {
    public class var banana: UIColor { .yellow100 }
    public class var cherry: UIColor { .red600 }
    public class var ice: UIColor { .aqua50 }
    public class var licorice: UIColor { .gray700 }
    public class var lime: UIColor { .green600 }
    public class var marble: UIColor { .blueGray50 }
    public class var milk: UIColor { .white }
    public class var mint: UIColor { .green100 }
    public class var pea: UIColor { .green400 }
    public class var primaryBlue: UIColor { .blue600 }
    public class var salmon: UIColor { .red100 }
    public class var sardine: UIColor { .blueGray300 }
    public class var secondaryBlue: UIColor { .aqua400 }
    public class var stone: UIColor { .gray500 }
    public class var toothPaste: UIColor { .aqua200 }
    public class var watermelon: UIColor { .red400 }
}

@available(*, deprecated, message: "Use Fabric colors instead")
extension CGColor {
    public class var banana: CGColor { UIColor.banana.cgColor }
    public class var cherry: CGColor { UIColor.cherry.cgColor }
    public class var ice: CGColor { UIColor.ice.cgColor }
    public class var licorice: CGColor { UIColor.licorice.cgColor }
    public class var lime: CGColor { UIColor.lime.cgColor }
    public class var marble: CGColor { UIColor.marble.cgColor }
    public class var milk: CGColor { UIColor.milk.cgColor }
    public class var mint: CGColor { UIColor.mint.cgColor }
    public class var pea: CGColor { UIColor.pea.cgColor }
    public class var primaryBlue: CGColor { UIColor.primaryBlue.cgColor }
    public class var salmon: CGColor { UIColor.salmon.cgColor }
    public class var sardine: CGColor { UIColor.sardine.cgColor }
    public class var secondaryBlue: CGColor { UIColor.secondaryBlue.cgColor }
    public class var stone: CGColor { UIColor.stone.cgColor }
    public class var toothPaste: CGColor { UIColor.toothPaste.cgColor }
    public class var watermelon: CGColor { UIColor.watermelon.cgColor }
}

// MARK: - Finn Custom Colors
// These colors are in use but are not part of the Fabric color palette
extension UIColor {
    public class var coolGray100: UIColor { .init(hex: "#F3F4F6") }
    public class var darkBgPrimaryProminent: UIColor { .init(hex: "#323241") }
    public class var darkCallToAction: UIColor { .init(hex: "#006DFB") }
    public class var darkIce: UIColor { .init(hex: "#262633") }
    public class var darkLicorice: UIColor { .init(hex: "#828699") }
    public class var darkMarble: UIColor { .init(hex: "#13131A") }
    public class var darkMilk: UIColor { .init(hex: "#1B1B24") }
    public class var darkPrimaryBlue: UIColor { .init(hex: "#3F8BFF") }
    public class var darkSardine: UIColor { .init(hex: "#434359") }
    public class var darkStone: UIColor { .init(hex: "#8A8EA1") }
    public class var midnightBackground: UIColor { .init(hex: "1D1D26") }
    public class var midnightSectionHeader: UIColor { .init(hex: "585E8A") }
    public class var midnightSectionSeparator: UIColor { .init(hex: "34343E") }
}

extension CGColor {
    public class var coolGray100: CGColor { UIColor.coolGray100.cgColor }
    public class var darkBgPrimaryProminent: CGColor { UIColor.darkBgPrimaryProminent.cgColor }
    public class var darkCallToAction: CGColor { UIColor.darkCallToAction.cgColor }
    public class var darkIce: CGColor { UIColor.darkIce.cgColor }
    public class var darkLicorice: CGColor { UIColor.darkLicorice.cgColor }
    public class var darkMarble: CGColor { UIColor.darkMarble.cgColor }
    public class var darkMilk: CGColor { UIColor.darkMilk.cgColor }
    public class var darkPrimaryBlue: CGColor { UIColor.darkPrimaryBlue.cgColor }
    public class var darkSardine: CGColor { UIColor.darkSardine.cgColor }
    public class var darkStone: CGColor { UIColor.darkStone.cgColor }
    public class var midnightBackground: CGColor { UIColor.midnightBackground.cgColor }
    public class var midnightSectionHeader: CGColor { UIColor.midnightSectionHeader.cgColor }
    public class var midnightSectionSeparator: CGColor { UIColor.midnightSectionSeparator.cgColor }
}

// MARK: - Fabric Colors Aqua
extension UIColor {
    public class var aqua50:  UIColor { .init(hex: "#F1F9FF") }
    public class var aqua100: UIColor { .init(hex: "#E0F6FF") }
    public class var aqua200: UIColor { .init(hex: "#B6F0FF") }
    public class var aqua300: UIColor { .init(hex: "#66E0FF") }
    public class var aqua400: UIColor { .init(hex: "#06BEFB") }
    public class var aqua500: UIColor { .init(hex: "#03A3DD") }
    public class var aqua600: UIColor { .init(hex: "#0386BF") }
    public class var aqua700: UIColor { .init(hex: "#1E648A") }
    public class var aqua800: UIColor { .init(hex: "#1D435A") }
    public class var aqua900: UIColor { .init(hex: "#15242F") }
}

extension CGColor {
    public class var aqua50:  CGColor { UIColor.aqua50.cgColor }
    public class var aqua100: CGColor { UIColor.aqua100.cgColor }
    public class var aqua200: CGColor { UIColor.aqua200.cgColor }
    public class var aqua300: CGColor { UIColor.aqua300.cgColor }
    public class var aqua400: CGColor { UIColor.aqua400.cgColor }
    public class var aqua500: CGColor { UIColor.aqua500.cgColor }
    public class var aqua600: CGColor { UIColor.aqua600.cgColor }
    public class var aqua700: CGColor { UIColor.aqua700.cgColor }
    public class var aqua800: CGColor { UIColor.aqua800.cgColor }
    public class var aqua900: CGColor { UIColor.aqua900.cgColor }
}

// MARK: - Fabric Colors Blue
extension UIColor {
    public class var blue50:  UIColor { .init(hex: "#EFF5FF") }
    public class var blue100: UIColor { .init(hex: "#E1EDFE") }
    public class var blue200: UIColor { .init(hex: "#C2DAFE") }
    public class var blue300: UIColor { .init(hex: "#9AC1FE") }
    public class var blue400: UIColor { .init(hex: "#5C9CFF") }
    public class var blue500: UIColor { .init(hex: "#2B7EFF") }
    public class var blue600: UIColor { .init(hex: "#0063FB") }
    public class var blue700: UIColor { .init(hex: "#244EB3") }
    public class var blue800: UIColor { .init(hex: "#223474") }
    public class var blue900: UIColor { .init(hex: "#191D3A") }
}

extension CGColor {
    public class var blue50:  CGColor { UIColor.blue50.cgColor }
    public class var blue100: CGColor { UIColor.blue100.cgColor }
    public class var blue200: CGColor { UIColor.blue200.cgColor }
    public class var blue300: CGColor { UIColor.blue300.cgColor }
    public class var blue400: CGColor { UIColor.blue400.cgColor }
    public class var blue500: CGColor { UIColor.blue500.cgColor }
    public class var blue600: CGColor { UIColor.blue600.cgColor }
    public class var blue700: CGColor { UIColor.blue700.cgColor }
    public class var blue800: CGColor { UIColor.blue800.cgColor }
    public class var blue900: CGColor { UIColor.blue900.cgColor }
}

// MARK: - Fabric Colors BlueGray
extension UIColor {
    public class var blueGray50:  UIColor { .init(hex: "#F8FAFC") }
    public class var blueGray100: UIColor { .init(hex: "#F1F4F9") }
    public class var blueGray200: UIColor { .init(hex: "#E1E6EE") }
    public class var blueGray300: UIColor { .init(hex: "#C3CCD9") }
    public class var blueGray400: UIColor { .init(hex: "#9BA8BA") }
    public class var blueGray500: UIColor { .init(hex: "#6F7D90") }
    public class var blueGray600: UIColor { .init(hex: "#4D586F") }
    public class var blueGray700: UIColor { .init(hex: "#3B4353") }
    public class var blueGray800: UIColor { .init(hex: "#292D38") }
    public class var blueGray900: UIColor { .init(hex: "#181A1F") }
}

extension CGColor {
    public class var blueGray50:  CGColor { UIColor.blueGray50.cgColor }
    public class var blueGray100: CGColor { UIColor.blueGray100.cgColor }
    public class var blueGray200: CGColor { UIColor.blueGray200.cgColor }
    public class var blueGray300: CGColor { UIColor.blueGray300.cgColor }
    public class var blueGray400: CGColor { UIColor.blueGray400.cgColor }
    public class var blueGray500: CGColor { UIColor.blueGray500.cgColor }
    public class var blueGray600: CGColor { UIColor.blueGray600.cgColor }
    public class var blueGray700: CGColor { UIColor.blueGray700.cgColor }
    public class var blueGray800: CGColor { UIColor.blueGray800.cgColor }
    public class var blueGray900: CGColor { UIColor.blueGray900.cgColor }
}

// MARK: - Fabric Colors Gray
extension UIColor {
    public class var gray50:  UIColor { .init(hex: "#FAFAFA") }
    public class var gray100: UIColor { .init(hex: "#F4F4F5") }
    public class var gray200: UIColor { .init(hex: "#E4E4E7") }
    public class var gray300: UIColor { .init(hex: "#D4D4D8") }
    public class var gray400: UIColor { .init(hex: "#A1A1AA") }
    public class var gray500: UIColor { .init(hex: "#71717A") }
    public class var gray600: UIColor { .init(hex: "#52525B") }
    public class var gray700: UIColor { .init(hex: "#3F3F46") }
    public class var gray800: UIColor { .init(hex: "#27272A") }
    public class var gray900: UIColor { .init(hex: "#18181B") }
}

extension CGColor {
    public class var gray50:  CGColor { UIColor.gray50.cgColor }
    public class var gray100: CGColor { UIColor.gray100.cgColor }
    public class var gray200: CGColor { UIColor.gray200.cgColor }
    public class var gray300: CGColor { UIColor.gray300.cgColor }
    public class var gray400: CGColor { UIColor.gray400.cgColor }
    public class var gray500: CGColor { UIColor.gray500.cgColor }
    public class var gray600: CGColor { UIColor.gray600.cgColor }
    public class var gray700: CGColor { UIColor.gray700.cgColor }
    public class var gray800: CGColor { UIColor.gray800.cgColor }
    public class var gray900: CGColor { UIColor.gray900.cgColor }
}

// MARK: - Fabric Colors Green
extension UIColor {
    public class var green50:  UIColor { .init(hex: "#EBFFF6") }
    public class var green100: UIColor { .init(hex: "#CDFEE5") }
    public class var green200: UIColor { .init(hex: "#9EFCD1") }
    public class var green300: UIColor { .init(hex: "#67EEB8") }
    public class var green400: UIColor { .init(hex: "#2EE69F") }
    public class var green500: UIColor { .init(hex: "#18C884") }
    public class var green600: UIColor { .init(hex: "#059E6F") }
    public class var green700: UIColor { .init(hex: "#1D7454") }
    public class var green800: UIColor { .init(hex: "#1B4D39") }
    public class var green900: UIColor { .init(hex: "#14291F") }
}

extension CGColor {
    public class var green50:  CGColor { UIColor.green50.cgColor }
    public class var green100: CGColor { UIColor.green100.cgColor }
    public class var green200: CGColor { UIColor.green200.cgColor }
    public class var green300: CGColor { UIColor.green300.cgColor }
    public class var green400: CGColor { UIColor.green400.cgColor }
    public class var green500: CGColor { UIColor.green500.cgColor }
    public class var green600: CGColor { UIColor.green600.cgColor }
    public class var green700: CGColor { UIColor.green700.cgColor }
    public class var green800: CGColor { UIColor.green800.cgColor }
    public class var green900: CGColor { UIColor.green900.cgColor }
}

// MARK: - Fabric Colors Red
extension UIColor {
    public class var red50:  UIColor { .init(hex: "#FFF5F5") }
    public class var red100: UIColor { .init(hex: "#FFEFEF") }
    public class var red200: UIColor { .init(hex: "#FFD1D1") }
    public class var red300: UIColor { .init(hex: "#FF9999") }
    public class var red400: UIColor { .init(hex: "#FF5844") }
    public class var red500: UIColor { .init(hex: "#FA270F") }
    public class var red600: UIColor { .init(hex: "#D91F0A") }
    public class var red700: UIColor { .init(hex: "#9E2216") }
    public class var red800: UIColor { .init(hex: "#681D11") }
    public class var red900: UIColor { .init(hex: "#38140B") }
}

extension CGColor {
    public class var red50:  CGColor { UIColor.red50.cgColor }
    public class var red100: CGColor { UIColor.red100.cgColor }
    public class var red200: CGColor { UIColor.red200.cgColor }
    public class var red300: CGColor { UIColor.red300.cgColor }
    public class var red400: CGColor { UIColor.red400.cgColor }
    public class var red500: CGColor { UIColor.red500.cgColor }
    public class var red600: CGColor { UIColor.red600.cgColor }
    public class var red700: CGColor { UIColor.red700.cgColor }
    public class var red800: CGColor { UIColor.red800.cgColor }
    public class var red900: CGColor { UIColor.red900.cgColor }
}

// MARK: - Fabric Colors Yellow
extension UIColor {
    public class var yellow50:  UIColor { .init(hex: "#FFF8E6") }
    public class var yellow100: UIColor { .init(hex: "#FFF5C8") }
    public class var yellow200: UIColor { .init(hex: "#FEEF90") }
    public class var yellow300: UIColor { .init(hex: "#FAE76B") }
    public class var yellow400: UIColor { .init(hex: "#FFE11F") }
    public class var yellow500: UIColor { .init(hex: "#EEB61B") }
    public class var yellow600: UIColor { .init(hex: "#D5840B") }
    public class var yellow700: UIColor { .init(hex: "#9B621E") }
    public class var yellow800: UIColor { .init(hex: "#654118") }
    public class var yellow900: UIColor { .init(hex: "#352310") }
}

extension CGColor {
    public class var yellow50:  CGColor { UIColor.yellow50.cgColor }
    public class var yellow100: CGColor { UIColor.yellow100.cgColor }
    public class var yellow200: CGColor { UIColor.yellow200.cgColor }
    public class var yellow300: CGColor { UIColor.yellow300.cgColor }
    public class var yellow400: CGColor { UIColor.yellow400.cgColor }
    public class var yellow500: CGColor { UIColor.yellow500.cgColor }
    public class var yellow600: CGColor { UIColor.yellow600.cgColor }
    public class var yellow700: CGColor { UIColor.yellow700.cgColor }
    public class var yellow800: CGColor { UIColor.yellow800.cgColor }
    public class var yellow900: CGColor { UIColor.yellow900.cgColor }
}

#if os(iOS)
public extension CGColor {
    // White, black and clear only exists on macOS for CGColor
    class var black: CGColor { .init(gray: 0, alpha: 1) }
    class var clear: CGColor { .init(gray: 0, alpha: 0) }
    class var white: CGColor { .init(gray: 1, alpha: 1) }
}
#endif

// MARK: - Button UIColors
@objc extension UIColor {
    public class var callToActionButtonHighlightedBodyColor: UIColor {
        return backgroundPrimary.withAlphaComponent(0.8)
    }

    public class var destructiveButtonHighlightedBodyColor: UIColor {
        return backgroundNegative.withAlphaComponent(0.8)
    }

    public class var utilityButtonHighlightedBorderColor: UIColor {
        return backgroundDisabled.withAlphaComponent(0.8)
    }

    public class var defaultButtonHighlightedBodyColor: UIColor {
        return dynamicColor(defaultColor: UIColor(r: 241, g: 249, b: 255), darkModeColor: UIColor(hex: "#13131A"))
    }

    public class var linkButtonHighlightedTextColor: UIColor {
        return textLink.withAlphaComponent(0.8)
    }

    public class var flatButtonHighlightedTextColor: UIColor {
        return textLink.withAlphaComponent(0.8)
    }

    public class var destructiveFlatButtonHighlightedTextColor: UIColor {
        return textNegative.withAlphaComponent(0.8)
    }

    public class var utilityButtonHighlightedTextColor: UIColor {
        return text.withAlphaComponent(0.8)
    }

    public class var dimmingColor: UIColor {
        return UIColor.black.withAlphaComponent(0.4) //DARK
    }
}

// MARK: - Highlighted buttons CGColors
extension CGColor {
    public class var callToActionButtonHighlightedBodyColor: CGColor {
        return UIColor.callToActionButtonHighlightedBodyColor.cgColor
    }

    public class var destructiveButtonHighlightedBodyColor: CGColor {
        return UIColor.destructiveButtonHighlightedBodyColor.cgColor
    }

    public class var defaultButtonHighlightedBodyColor: CGColor {
        return UIColor.defaultButtonHighlightedBodyColor.cgColor
    }

    public class var linkButtonHighlightedTextColor: CGColor {
        return UIColor.linkButtonHighlightedTextColor.cgColor
    }

    public class var flatButtonHighlightedTextColor: CGColor {
        return UIColor.flatButtonHighlightedTextColor.cgColor
    }
}

// MARK: - Cell UIColors

@objc extension UIColor {
    public class var defaultCellSelectedBackgroundColor: UIColor {
        let lightSelectedColor = UIColor(r: 230, g: 235, b: 242)
        return dynamicColor(defaultColor: lightSelectedColor, darkModeColor: lightSelectedColor.withAlphaComponent(0.1))
    }
}

extension CGColor {
    public class var defaultCellSelectedBackgroundColor: CGColor {
        return UIColor.defaultCellSelectedBackgroundColor.cgColor
    }
}

// MARK: - Public color creation methods
public extension UIColor {
    /// The UIColor initializer we need it's more natural to write integer values from 0 to 255 than decimas from 0 to 1
    /// - Parameters:
    ///   - r: red (0-255)
    ///   - g: green (0-255)
    ///   - b: blue (0-255)
    ///   - a: alpla (0-1)
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) { // swiftlint:disable:this identifier_name
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    /// Base initializer, it creates an instance of `UIColor` using an HEX string.
    ///
    /// - Parameter hex: The base HEX string to create the color.
    convenience init(hex: String) {
        let noHashString = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: noHashString)
        scanner.charactersToBeSkipped = CharacterSet.symbols

        var hexInt: UInt64 = 0
        if scanner.scanHexInt64(&hexInt) {
            let red = (hexInt >> 16) & 0xFF
            let green = (hexInt >> 8) & 0xFF
            let blue = (hexInt) & 0xFF

            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }

    /// Convenience method to create dynamic colors for dark mode if the OS supports it (independant of FinniversKit
    /// settings)
    /// - Parameters:
    ///   - defaultColor: light mode version of the color
    ///   - darkModeColor: dark mode version of the color
    class func dynamicColor(defaultColor: UIColor, darkModeColor: UIColor) -> UIColor {
        UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return darkModeColor
            default:
                return defaultColor
            }
        }
    }

    /// Returns hexadecimal representation of a color converted to the sRGB color space.
    var hexString: String {
        guard
            let targetColorSpace = CGColorSpace(name: CGColorSpace.sRGB),
            let cgColor = self.cgColor.converted(to: targetColorSpace, intent: .relativeColorimetric, options: nil)
        else {
            // Not possible to convert source color space to RGB
            return "#000000"
        }
        let components = cgColor.components
        let red = components?[0] ?? 0.0
        let green = components?[1] ?? 0.0
        let blue = components?[2] ?? 0.0
        return String(format: "#%02x%02x%02x", (Int)(red * 255), (Int)(green * 255), (Int)(blue * 255))
    }

    @available(*, deprecated, message: "Use dynamicColor(defaultColor:darkModeColor:) instead.")
    class func dynamicColorIfAvailable(defaultColor: UIColor, darkModeColor: UIColor) -> UIColor {
        dynamicColor(defaultColor: defaultColor, darkModeColor: darkModeColor)
    }
}
