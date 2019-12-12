//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - Semantic colors, dark mode compatible
@objc extension UIColor {
    public class var bgPrimary: UIColor {
        return dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: UIColor(hex: "#1B1B24"))
    }

    public class var bgSecondary: UIColor {
        return dynamicColorIfAvailable(defaultColor: .ice, darkModeColor: .darkIce)
    }

    public class var bgTertiary: UIColor {
        return dynamicColorIfAvailable(defaultColor: .marble, darkModeColor: UIColor(hex: "#13131A"))
    }

    public class var bgBottomSheet: UIColor {
        return dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: .darkIce)
    }

    public class var bgAlert: UIColor {
        return .banana
    }

    public class var bgSuccess: UIColor {
        return .mint
    }

    public class var bgCritical: UIColor {
        return .salmon
    }

    public class var btnPrimary: UIColor {
        return dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: UIColor(hex: "#006DFB"))
    }

    public class var btnDisabled: UIColor {
        return dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public class var btnCritical: UIColor {
        return .cherry
    }

    public class var textPrimary: UIColor {
        return dynamicColorIfAvailable(defaultColor: .licorice, darkModeColor: .milk)
    }

    public class var textSecondary: UIColor {
        return dynamicColorIfAvailable(defaultColor: .stone, darkModeColor: UIColor(hex: "#828699"))
    }

    public class var textTertiary: UIColor {
        return .milk
    }

    public class var textAction: UIColor {
        return dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: UIColor(hex: "#3F8BFF"))
    }

    public class var textDisabled: UIColor {
        return dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public class var textCritical: UIColor {
        return dynamicColorIfAvailable(defaultColor: .cherry, darkModeColor: .watermelon)
    }

    public class var accentSecondaryBlue: UIColor {
        return .secondaryBlue
    }

    public class var accentPea: UIColor {
        return .pea
    }

    public class var accentToothpaste: UIColor {
        return .toothPaste
    }

    public class var textCTADisabled: UIColor {
        return dynamicColorIfAvailable(defaultColor: .licorice, darkModeColor: UIColor(hex: "#828699"))
    }

    public class var textToast: UIColor {
        return .licorice
    }

    public class var tableViewSeparator: UIColor {
        return dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public class var imageBorder: UIColor {
        return dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public class var decorationSubtle: UIColor {
        return .btnDisabled
    }

    public class var iconPrimary: UIColor {
        return .textPrimary
    }

    public class var iconSecondary: UIColor {
        return .textTertiary
    }
}

// MARK: - FINN UIColors
@objc extension UIColor {
    public class var ice: UIColor {
        return UIColor(r: 241, g: 249, b: 255)!
    }

    public class var milk: UIColor {
        return UIColor(r: 255, g: 255, b: 255)!
    }

    public class var licorice: UIColor {
        return UIColor(r: 71, g: 68, b: 69)!
    }

    public class var primaryBlue: UIColor {
        return UIColor(r: 0, g: 99, b: 251)!
    }

    public class var secondaryBlue: UIColor {
        return UIColor(r: 6, g: 190, b: 251)!
    }

    public class var stone: UIColor {
        return UIColor(r: 118, g: 118, b: 118)!
    }

    public class var sardine: UIColor {
        return UIColor(r: 195, g: 204, b: 217)!
    }

    public class var darkSardine: UIColor {
        return UIColor(hex: "434359")
    }

    public class var salmon: UIColor {
        return UIColor(r: 255, g: 239, b: 239)!
    }

    public class var mint: UIColor {
        return UIColor(r: 204, g: 255, b: 236)!
    }

    public class var toothPaste: UIColor {
        return UIColor(r: 182, g: 240, b: 255)!
    }

    public class var banana: UIColor {
        return UIColor(r: 255, g: 245, b: 200)!
    }

    public class var cherry: UIColor {
        return UIColor(r: 217, g: 39, b: 10)!
    }

    public class var watermelon: UIColor {
        return UIColor(r: 255, g: 88, b: 68)!
    }

    public class var pea: UIColor {
        return UIColor(r: 46, g: 230, b: 159)!
    }

    public class var marble: UIColor {
        return UIColor(r: 246, g: 248, b: 251)!
    }

    public class var midnightBackground: UIColor {
        return UIColor(hex: "1D1D26")
    }

    public class var midnightSectionHeader: UIColor {
        return UIColor(hex: "585E8A")
    }

    public class var midnightSectionSeparator: UIColor {
        return UIColor(hex: "34343E")
    }

    public class var darkIce: UIColor {
        return UIColor(hex: "#262633")
    }

    // swiftlint:disable:next identifier_name
    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    /// Base initializer, it creates an instance of `UIColor` using an HEX string.
    ///
    /// - Parameter hex: The base HEX string to create the color.
    private convenience init(hex: String) {
        let noHashString = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: noHashString)
        scanner.charactersToBeSkipped = CharacterSet.symbols

        var hexInt: UInt32 = 0
        if scanner.scanHexInt32(&hexInt) {
            let red = (hexInt >> 16) & 0xFF
            let green = (hexInt >> 8) & 0xFF
            let blue = (hexInt) & 0xFF

            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
}

// MARK: - FINN CGColors
extension CGColor {
    public class var ice: CGColor {
        return UIColor.ice.cgColor
    }

    public class var milk: CGColor {
        return UIColor.milk.cgColor
    }

    public class var licorice: CGColor {
        return UIColor.licorice.cgColor
    }

    public class var primaryBlue: CGColor {
        return UIColor.primaryBlue.cgColor
    }

    public class var secondaryBlue: CGColor {
        return UIColor.secondaryBlue.cgColor
    }

    public class var stone: CGColor {
        return UIColor.stone.cgColor
    }

    public class var sardine: CGColor {
        return UIColor.sardine.cgColor
    }

    public class var salmon: CGColor {
        return UIColor.salmon.cgColor
    }

    public class var mint: CGColor {
        return UIColor.mint.cgColor
    }

    public class var toothPaste: CGColor {
        return UIColor.toothPaste.cgColor
    }

    public class var banana: CGColor {
        return UIColor.banana.cgColor
    }

    public class var cherry: CGColor {
        return UIColor.cherry.cgColor
    }

    public class var watermelon: CGColor {
        return UIColor.watermelon.cgColor
    }

    public class var pea: CGColor {
        return UIColor.pea.cgColor
    }

    public class var marble: CGColor {
        return UIColor.marble.cgColor
    }
}

// MARK: - Semantic CGColors
extension CGColor {
    public class var bgPrimary: CGColor {
        return UIColor.bgPrimary.cgColor
    }

    public class var bgSecondary: CGColor {
        return UIColor.bgSecondary.cgColor
    }

    public class var bgTertiary: CGColor {
        return UIColor.bgTertiary.cgColor
    }

    public class var bgAlert: CGColor {
        return UIColor.bgAlert.cgColor
    }

    public class var bgSuccess: CGColor {
        return UIColor.bgSuccess.cgColor
    }

    public class var bgCritical: CGColor {
        return UIColor.bgCritical.cgColor
    }

    public class var btnPrimary: CGColor {
        return UIColor.btnPrimary.cgColor
    }

    public class var btnDisabled: CGColor {
        return UIColor.btnDisabled.cgColor
    }

    public class var btnCritical: CGColor {
        return UIColor.btnCritical.cgColor
    }

    public class var textPrimary: CGColor {
        return UIColor.textPrimary.cgColor
    }

    public class var textSecondary: CGColor {
        return UIColor.textSecondary.cgColor
    }

    public class var textTertiary: CGColor {
        return UIColor.textTertiary.cgColor
    }

    public class var textAction: CGColor {
        return UIColor.textAction.cgColor
    }

    public class var textDisabled: CGColor {
        return UIColor.textDisabled.cgColor
    }

    public class var textCritical: CGColor {
        return UIColor.textCritical.cgColor
    }

    public class var accentSecondaryBlue: CGColor {
        return UIColor.accentSecondaryBlue.cgColor
    }

    public class var accentPea: CGColor {
        return UIColor.accentPea.cgColor
    }

    public class var accentToothpaste: CGColor {
        return UIColor.accentToothpaste.cgColor
    }

    public class var textCTADisabled: CGColor {
        return UIColor.textCTADisabled.cgColor
    }

    public class var textToast: CGColor {
        return UIColor.textToast.cgColor
    }

    public class var tableViewSeparator: CGColor {
        return UIColor.tableViewSeparator.cgColor
    }

    public class var imageBorder: CGColor {
        return UIColor.imageBorder.cgColor
    }

    public class var decorationSubtle: CGColor {
        return UIColor.decorationSubtle.cgColor
    }

    public class var iconPrimary: CGColor {
        return UIColor.iconPrimary.cgColor
    }

    public class var iconSecondary: CGColor {
        return UIColor.iconSecondary.cgColor
    }
}

// MARK: - Button UIColors
@objc extension UIColor {
    public class var callToActionButtonHighlightedBodyColor: UIColor {
        return btnPrimary.withAlphaComponent(0.8)
    }

    public class var destructiveButtonHighlightedBodyColor: UIColor {
        return btnCritical.withAlphaComponent(0.8)
    }

    public class var utilityButtonHighlightedBorderColor: UIColor {
        return btnDisabled.withAlphaComponent(0.8)
    }

    public class var defaultButtonHighlightedBodyColor: UIColor {
        return UIColor(r: 241, g: 249, b: 255)! //DARK btnTertiary?
    }

    public class var linkButtonHighlightedTextColor: UIColor {
        return textAction.withAlphaComponent(0.8)
    }

    public class var flatButtonHighlightedTextColor: UIColor {
        return textAction.withAlphaComponent(0.8)
    }

    public class var destructiveFlatButtonHighlightedTextColor: UIColor {
        return textCritical.withAlphaComponent(0.8)
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
        let lightSelectedColor = UIColor(r: 230, g: 235, b: 242)!
        return dynamicColorIfAvailable(defaultColor: lightSelectedColor, darkModeColor: lightSelectedColor.withAlphaComponent(0.4))
    }
}

extension CGColor {
    public class var defaultCellSelectedBackgroundColor: CGColor {
        return UIColor.defaultCellSelectedBackgroundColor.cgColor
    }
}

// MARK: - Private helper for creating dynamic color
extension UIColor {
    class func dynamicColorIfAvailable(defaultColor: UIColor, darkModeColor: UIColor) -> UIColor {
        switch FinniversKit.userInterfaceStyleSupport {
        case .forceDark:
            return darkModeColor
        case .forceLight:
            return defaultColor
        case .dynamic:
            if #available(iOS 13.0, *) {
                #if swift(>=5.1)
                return UIColor { traitCollection -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        return darkModeColor
                    default:
                        return defaultColor
                    }
                }
                #endif
            }
            return defaultColor
        }
    }
}
