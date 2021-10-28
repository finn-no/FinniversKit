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
    var shadowColor: UIColor { get }
}

// MARK: - Default FINN colors

public struct DefaultColorProvider: ColorProvider {
    public var bgPrimary: UIColor {
        .dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: UIColor(hex: "#1B1B24"))
    }

    public var bgSecondary: UIColor {
        .dynamicColorIfAvailable(defaultColor: .ice, darkModeColor: .darkIce)
    }

    public var bgTertiary: UIColor {
        .dynamicColorIfAvailable(defaultColor: .marble, darkModeColor: UIColor(hex: "#13131A"))
    }
    
    public var bgQuaternary: UIColor {
        .dynamicColorIfAvailable(defaultColor: .marble, darkModeColor: UIColor(hex: "#1B1B24"))
    }

    public var bgBottomSheet: UIColor {
        .dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: .darkIce)
    }

    public var bgAlert: UIColor {
        .banana
    }

    public var bgSuccess: UIColor {
        .mint
    }

    public var bgCritical: UIColor {
        .salmon
    }

    public var btnPrimary: UIColor {
        .dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: UIColor(hex: "#006DFB"))
    }

    public var btnDisabled: UIColor {
        .dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public var btnCritical: UIColor {
        .cherry
    }

    public var btnAction: UIColor {
        .dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: UIColor(hex: "#3F8BFF"))
    }

    public var textPrimary: UIColor {
        .dynamicColorIfAvailable(defaultColor: .licorice, darkModeColor: .milk)
    }

    public var textSecondary: UIColor {
        .dynamicColorIfAvailable(defaultColor: .stone, darkModeColor: UIColor(hex: "#828699"))
    }

    public var textTertiary: UIColor {
        .milk
    }

    public var textAction: UIColor {
        .dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: UIColor(hex: "#3F8BFF"))
    }

    public var textDisabled: UIColor {
        .dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public var textCritical: UIColor {
        .dynamicColorIfAvailable(defaultColor: .cherry, darkModeColor: .watermelon)
    }

    public var accentSecondaryBlue: UIColor {
        .secondaryBlue
    }

    public var accentPea: UIColor {
        .pea
    }

    public var accentToothpaste: UIColor {
        .toothPaste
    }

    public var textCTADisabled: UIColor {
        .dynamicColorIfAvailable(defaultColor: .licorice, darkModeColor: UIColor(hex: "#828699"))
    }

    public var textToast: UIColor {
        .licorice
    }

    public var tableViewSeparator: UIColor {
        .dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public var imageBorder: UIColor {
        .dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
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
    
    public var shadowColor: UIColor {
        return UIColor(hex: "475569")
    }
}
