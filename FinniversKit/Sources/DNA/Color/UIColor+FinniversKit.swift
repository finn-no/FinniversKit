//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import SwiftUI
import Warp

// MARK: - Warp colors
extension Color {
    public static var background: Color { Warp.Token.background }
    public static var backgroundInfoSubtle: Color { Warp.Token.backgroundInfoSubtle }
    public static var backgroundSubtle: Color { Warp.Token.backgroundSubtle }
    public static var backgroundWarningSubtle: Color { Warp.Token.backgroundWarningSubtle }
    public static var backgroundPositiveSubtle: Color { Warp.Token.backgroundPositiveSubtle }
    public static var backgroundNegativeSubtle: Color { Warp.Token.backgroundNegativeSubtle }
    public static var backgroundNegativeActive: Color { Warp.Token.backgroundNegativeActive }
    public static var backgroundPrimary: Color { Warp.Token.backgroundPrimary }
    public static var backgroundPrimarySubtle: Color { Warp.Token.backgroundPrimarySubtle }
    public static var backgroundPrimaryActive: Color { Warp.Token.backgroundPrimaryActive }
    public static var backgroundDisabled: Color { Warp.Token.backgroundDisabled }
    public static var backgroundNegative: Color { Warp.Token.backgroundNegative }
    public static var backgroundActive: Color { Warp.Token.backgroundActive }
    public static var backgroundPositive: Color { Warp.Token.backgroundPositive }
    public static var text: Color { Warp.Token.text }
    public static var textStatic: Color { Warp.Token.textStatic }
    public static var textSubtle: Color { Warp.Token.textSubtle }
    public static var textInverted: Color { Warp.Token.textInverted }
    public static var textInvertedStatic: Color { Warp.Token.textInvertedStatic }
    public static var textLink: Color { Warp.Token.textLink }
    public static var textDisabled: Color { Warp.Token.textDisabled }
    public static var textNegative: Color { Warp.Token.textNegative }
    public static var border: Color { Warp.Token.border }
    public static var borderActive: Color { Warp.Token.borderActive }
    public static var borderPrimary: Color { Warp.Token.borderPrimary }
    public static var borderPrimarySubtle: Color { Warp.Token.borderPrimarySubtle }
    public static var borderPositive: Color { Warp.Token.borderPositive }
    public static var borderWarning: Color { Warp.Token.borderWarning }
    public static var borderDisabled: Color { Warp.Token.borderDisabled }
    public static var borderFocus: Color { Warp.Token.borderFocus }
    public static var borderNegative: Color { Warp.Token.borderNegative }
    public static var iconPrimary: Color { Warp.Token.iconPrimary }
    public static var iconInverted: Color { Warp.Token.iconInverted }
    public static var iconInvertedStatic: Color { Warp.Token.iconInvertedStatic }
    public static var icon: Color { Warp.Token.icon }
    public static var iconSubtle: Color { Warp.Token.iconSubtle }
    public static var iconSecondary: Color { Warp.Token.iconSecondary }
    public static var iconWarning: Color { Warp.Token.iconWarning }
    public static var surfaceSunken: Color { Warp.Token.surfaceSunken }
    public static var surfaceElevated100: Color { Warp.Token.surfaceElevated100 }
    public static var surfaceElevated200: Color { Warp.Token.surfaceElevated200 }
    public static var surfaceElevated300: Color { Warp.Token.surfaceElevated300 }
}

@objc extension UIColor {
    public static var background: UIColor { Warp.UIToken.background }
    public static var backgroundInfoSubtle: UIColor { Warp.UIToken.backgroundInfoSubtle }
    public static var backgroundSubtle: UIColor { Warp.UIToken.backgroundSubtle }
    public static var backgroundWarningSubtle: UIColor { Warp.UIToken.backgroundWarningSubtle }
    public static var backgroundPositiveSubtle: UIColor { Warp.UIToken.backgroundPositiveSubtle }
    public static var backgroundNegativeSubtle: UIColor { Warp.UIToken.backgroundNegativeSubtle }
    public static var backgroundNegativeActive: UIColor { Warp.UIToken.backgroundNegativeActive }
    public static var backgroundPrimary: UIColor { Warp.UIToken.backgroundPrimary }
    public static var backgroundPrimarySubtle: UIColor { Warp.UIToken.backgroundPrimarySubtle }
    public static var backgroundPrimaryActive: UIColor { Warp.UIToken.backgroundPrimaryActive }
    public static var backgroundDisabled: UIColor { Warp.UIToken.backgroundDisabled }
    public static var backgroundNegative: UIColor { Warp.UIToken.backgroundNegative }
    public static var backgroundActive: UIColor { Warp.UIToken.backgroundActive }
    public static var backgroundPositive: UIColor { Warp.UIToken.backgroundPositive }
    public static var text: UIColor { Warp.UIToken.text }
    public static var textStatic: UIColor { Warp.UIToken.textStatic }
    public static var textSubtle: UIColor { Warp.UIToken.textSubtle }
    public static var textInverted: UIColor { Warp.UIToken.textInverted }
    public static var textInvertedStatic: UIColor { Warp.UIToken.textInvertedStatic }
    public static var textLink: UIColor { Warp.UIToken.textLink }
    public static var textDisabled: UIColor { Warp.UIToken.textDisabled }
    public static var textNegative: UIColor { Warp.UIToken.textNegative }
    public static var border: UIColor { Warp.UIToken.border }
    public static var borderActive: UIColor { Warp.UIToken.borderActive }
    public static var borderPrimary: UIColor { Warp.UIToken.borderPrimary }
    public static var borderPrimarySubtle: UIColor { Warp.UIToken.borderPrimarySubtle }
    public static var borderPositive: UIColor { Warp.UIToken.borderPositive }
    public static var borderWarning: UIColor { Warp.UIToken.borderWarning }
    public static var borderDisabled: UIColor { Warp.UIToken.borderDisabled }
    public static var borderFocus: UIColor { Warp.UIToken.borderFocus }
    public static var borderNegative: UIColor { Warp.UIToken.borderNegative }
    public static var iconPrimary: UIColor { Warp.UIToken.iconPrimary }
    public static var iconInverted: UIColor { Warp.UIToken.iconInverted }
    public static var iconInvertedStatic: UIColor { Warp.UIToken.iconInvertedStatic }
    public static var icon: UIColor { Warp.UIToken.icon }
    public static var iconSubtle: UIColor { Warp.UIToken.iconSubtle }
    public static var iconSecondary: UIColor { Warp.UIToken.iconSecondary }
    public static var iconWarning: UIColor { Warp.UIToken.iconWarning }
    public static var surfaceSunken: UIColor { Warp.UIToken.surfaceSunken }
    public static var surfaceElevated100: UIColor { Warp.UIToken.surfaceElevated100 }
    public static var surfaceElevated200: UIColor { Warp.UIToken.surfaceElevated200 }
    public static var surfaceElevated300: UIColor { Warp.UIToken.surfaceElevated300 }
}

extension CGColor {
    public class var background: CGColor { UIColor.background.cgColor }
    public class var backgroundInfoSubtle: CGColor { UIColor.backgroundInfoSubtle.cgColor }
    public class var backgroundSubtle: CGColor { UIColor.backgroundSubtle.cgColor }
    public class var backgroundWarningSubtle: CGColor { UIColor.backgroundWarningSubtle.cgColor }
    public class var backgroundPositiveSubtle: CGColor { UIColor.backgroundPositiveSubtle.cgColor }
    public class var backgroundNegativeSubtle: CGColor { UIColor.backgroundNegativeSubtle.cgColor }
    public class var backgroundNegativeActive: CGColor { UIColor.backgroundNegativeActive.cgColor }
    public class var backgroundPrimary: CGColor { UIColor.backgroundPrimary.cgColor }
    public class var backgroundPrimarySubtle: CGColor { UIColor.backgroundPrimarySubtle.cgColor }
    public class var backgroundPrimaryActive: CGColor { UIColor.backgroundPrimaryActive.cgColor }
    public class var backgroundDisabled: CGColor { UIColor.backgroundDisabled.cgColor }
    public class var backgroundNegative: CGColor { UIColor.backgroundNegative.cgColor }
    public class var backgroundActive: CGColor { UIColor.backgroundActive.cgColor }
    public class var backgroundPositive: CGColor { UIColor.backgroundPositive.cgColor }
    public class var text: CGColor { UIColor.text.cgColor }
    public class var textStatic: CGColor { UIColor.textStatic.cgColor }
    public class var textSubtle: CGColor { UIColor.textSubtle.cgColor }
    public class var textInverted: CGColor { UIColor.textInverted.cgColor }
    public class var textInvertedStatic: CGColor { UIColor.textInvertedStatic.cgColor }
    public class var textLink: CGColor { UIColor.textLink.cgColor }
    public class var textDisabled: CGColor { UIColor.textDisabled.cgColor }
    public class var textNegative: CGColor { UIColor.textNegative.cgColor }
    public class var border: CGColor { UIColor.border.cgColor }
    public class var borderActive: CGColor { UIColor.borderActive.cgColor }
    public class var borderPrimary: CGColor { UIColor.borderPrimary.cgColor }
    public class var borderPrimarySubtle: CGColor { UIColor.borderPrimarySubtle.cgColor }
    public class var borderPositive: CGColor { UIColor.borderPositive.cgColor }
    public class var borderWarning: CGColor { UIColor.borderWarning.cgColor }
    public class var borderDisabled: CGColor { UIColor.borderDisabled.cgColor }
    public class var borderFocus: CGColor { UIColor.borderFocus.cgColor }
    public class var borderNegative: CGColor { UIColor.borderNegative.cgColor }
    public class var iconPrimary: CGColor { UIColor.iconPrimary.cgColor }
    public class var iconInverted: CGColor { UIColor.iconInverted.cgColor }
    public class var iconInvertedStatic: CGColor { UIColor.iconInvertedStatic.cgColor }
    public class var icon: CGColor { UIColor.icon.cgColor }
    public class var iconSubtle: CGColor { UIColor.iconSubtle.cgColor }
    public class var iconSecondary: CGColor { UIColor.iconSecondary.cgColor }
    public class var iconWarning: CGColor { UIColor.iconWarning.cgColor }
    public class var surfaceSunken: CGColor { UIColor.surfaceSunken.cgColor }
    public class var surfaceElevated100: CGColor { UIColor.surfaceElevated100.cgColor }
    public class var surfaceElevated200: CGColor { UIColor.surfaceElevated200.cgColor }
    public class var surfaceElevated300: CGColor { UIColor.surfaceElevated300.cgColor }
}

// MARK: - FINN UIColors (deprecated)
@available(*, deprecated, message: "Use Fabric colors instead")
@objc extension UIColor {
    public class var cherry: UIColor { .red600 }
    public class var ice: UIColor { .aqua50 }
    public class var licorice: UIColor { .gray700 }
    public class var marble: UIColor { .blueGray50 }
    public class var milk: UIColor { .white }
    public class var primaryBlue: UIColor { .blue600 }
    public class var stone: UIColor { .gray500 }

    public class var aqua50: UIColor { .init(hex: "#F1F9FF") }
    public class var blue600: UIColor { .init(hex: "#0063FB") }
    public class var blueGray50: UIColor { .init(hex: "#F8FAFC") }
    public class var gray500: UIColor { .init(hex: "#71717A") }
    public class var gray700: UIColor { .init(hex: "#3F3F46") }
    public class var red600: UIColor { .init(hex: "#D91F0A") }
}
