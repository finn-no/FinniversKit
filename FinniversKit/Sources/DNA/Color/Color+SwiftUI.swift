//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

// swiftlint:disable opening_brace

extension Color {
    // MARK: - Background

    public static var bgPrimary: Color     { Color(UIColor.bgPrimary) }
    public static var bgSecondary: Color   { Color(UIColor.bgSecondary) }
    public static var bgTertiary: Color    { Color(UIColor.bgTertiary) }
    public static var bgQuaternary: Color  { Color(UIColor.bgQuaternary) }
    public static var bgBottomSheet: Color { Color(UIColor.bgBottomSheet) }
    public static var bgAlert: Color       { Color(UIColor.bgAlert) }
    public static var bgSuccess: Color     { Color(UIColor.bgSuccess) }
    public static var bgCritical: Color    { Color(UIColor.bgCritical) }

    // MARK: - Button

    public static var btnPrimary: Color  { Color(UIColor.btnPrimary) }
    public static var btnDisabled: Color { Color(UIColor.btnDisabled) }
    public static var btnCritical: Color { Color(UIColor.btnCritical) }
    public static var btnAction: Color   { Color(UIColor.btnAction) }

    // MARK: - Text

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

    public static var accentSecondaryBlue: Color { Color(UIColor.accentSecondaryBlue) }
    public static var accentPea: Color           { Color(UIColor.accentPea) }
    public static var accentToothpaste: Color    { Color(UIColor.accentToothpaste) }
    public static var tableViewSeparator: Color  { Color(UIColor.tableViewSeparator) }
    public static var imageBorder: Color         { Color(UIColor.imageBorder) }
    public static var decorationSubtle: Color    { Color(UIColor.decorationSubtle) }
    public static var borderDefault: Color       { Color(UIColor.borderDefault) }
}

extension Color {
    public static func finnColor(_ color: UIColor) -> Color {
        Color(color)
    }
}
