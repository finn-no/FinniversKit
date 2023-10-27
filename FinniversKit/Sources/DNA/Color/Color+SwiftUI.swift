//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

// swiftlint:disable opening_brace

extension Color {
    // MARK: - Background

    @available(*, deprecated, message: "Use Warp background instead")
    public static var bgPrimary: Color     { Color(UIColor.bgPrimary) }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    public static var bgSecondary: Color   { Color(UIColor.bgSecondary) }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    public static var bgTertiary: Color    { Color(UIColor.bgTertiary) }
    @available(*, deprecated, message: "Use Warp backgroundSubtle instead")
    public static var bgQuaternary: Color  { Color(UIColor.bgQuaternary) }
    @available(*, deprecated, message: "Use Warp background instead")
    public static var bgBottomSheet: Color { Color(UIColor.bgBottomSheet) }
    @available(*, deprecated, message: "Use Warp backgroundWarningSubtle instead")
    public static var bgAlert: Color       { Color(UIColor.bgAlert) }
    @available(*, deprecated, message: "Use Warp backgroundPositiveSubtle instead")
    public static var bgSuccess: Color     { Color(UIColor.bgSuccess) }
    @available(*, deprecated, message: "Use Warp backgroundNegativeSubtle instead")
    public static var bgCritical: Color    { Color(UIColor.bgCritical) }
    @available(*, deprecated, message: "Use Warp backgroundInfoSubtle instead")
    public static var bgInfo: Color        { Color(UIColor.bgInfo) }
    @available(*, deprecated, message: "Use Warp color instead")
    public static var bgInfoHeader: Color  { Color(UIColor.bgInfoHeader) }

    // MARK: - Button
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public static var btnPrimary: Color  { Color(UIColor.btnPrimary) }
    @available(*, deprecated, message: "Use Warp backgroundDisabled instead")
    public static var btnDisabled: Color { Color(UIColor.btnDisabled) }
    @available(*, deprecated, message: "Use Warp backgroundNegative instead")
    public static var btnCritical: Color { Color(UIColor.btnCritical) }
    @available(*, deprecated, message: "Use Warp backgroundPrimary instead")
    public static var btnAction: Color   { Color(UIColor.btnAction) }

    // MARK: - Text
    @available(*, deprecated, message: "Use Warp text instead")
    public static var textPrimary: Color     { Color(UIColor.textPrimary) }
    public static var textSecondary: Color   { Color(UIColor.textSecondary) }
    public static var textTertiary: Color    { Color(UIColor.textTertiary) }
    public static var textAction: Color      { Color(UIColor.textAction) }
    public static var textDisabled: Color    { Color(UIColor.textDisabled) }
    public static var textCritical: Color    { Color(UIColor.textCritical) }
    public static var textToast: Color       { Color(UIColor.textToast) }
    public static var textCTADisabled: Color { Color(UIColor.textCTADisabled) }

    // MARK: - Icon

    public static var iconPrimary: Color   { Color(UIColor.iconPrimary) }
    public static var iconSecondary: Color { Color(UIColor.iconSecondary) }
    public static var iconTertiary: Color  { Color(UIColor.iconTertiary) }

    // MARK: - Others

    public static var accentPrimaryBlue: Color   { Color(UIColor.accentPrimaryBlue)}
    public static var accentSecondaryBlue: Color { Color(UIColor.accentSecondaryBlue) }
    public static var accentPea: Color           { Color(UIColor.accentPea) }
    public static var accentToothpaste: Color    { Color(UIColor.accentToothpaste) }
    public static var tableViewSeparator: Color  { Color(UIColor.tableViewSeparator) }
    public static var imageBorder: Color         { Color(UIColor.imageBorder) }
    public static var decorationSubtle: Color    { Color(UIColor.decorationSubtle) }
    public static var borderDefault: Color       { Color(UIColor.borderDefault) }
}
// swiftlint:enable opening_brace
