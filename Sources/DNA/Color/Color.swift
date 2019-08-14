//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

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

    public class var salmon: UIColor {
        return UIColor(r: 255, g: 227, b: 229)!
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
        return UIColor(r: 228, g: 41, b: 10)!
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

    public class var charcoal: UIColor {
        return UIColor(hex: "1D1D26")
    }

    public class var blueberry: UIColor {
        return UIColor(hex: "585E8A")
    }

    // swiftlint:disable:next identifier_name
    convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    /// Base initializer, it creates an instance of `UIColor` using an HEX string.
    ///
    /// - Parameter hex: The base HEX string to create the color.
    convenience init(hex: String) {
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

// MARK: - Button

@objc extension UIColor {
    public class var callToActionButtonHighlightedBodyColor: UIColor {
        return primaryBlue.withAlphaComponent(0.8)
    }

    public class var destructiveButtonHighlightedBodyColor: UIColor {
        return cherry.withAlphaComponent(0.8)
    }

    public class var defaultButtonHighlightedBodyColor: UIColor {
        switch Theme.currentStyle {
        case .light: return UIColor(r: 241, g: 249, b: 255)!
        case .dark: return UIColor(r: 241, g: 249, b: 255)!.withAlphaComponent(0.1)
        }
    }

    public class var linkButtonHighlightedTextColor: UIColor {
        return primaryBlue.withAlphaComponent(0.8)
    }

    public class var flatButtonHighlightedTextColor: UIColor {
        return primaryBlue.withAlphaComponent(0.8)
    }
}

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

// MARK: - Cell

@objc extension UIColor {
    public class var defaultCellSelectedBackgroundColor: UIColor {
        return UIColor(r: 230, g: 235, b: 242)!
    }
}

extension CGColor {
    public class var defaultCellSelectedBackgroundColor: CGColor {
        return UIColor.defaultCellSelectedBackgroundColor.cgColor
    }
}

// MARK: - Semantic colors that will support dark and light mode
@objc extension UIColor {
    public class var foregroundColor: UIColor {
        return dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: .charcoal)
    }

    public class var foregroundTintColor: UIColor {
        return dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: .secondaryBlue)
    }

    public class var primaryLabelTextColor: UIColor {
        return dynamicColorIfAvailable(defaultColor: .licorice, darkModeColor: .milk)
    }

    public class var secondaryLabelTextColor: UIColor {
        return dynamicColorIfAvailable(defaultColor: .licorice, darkModeColor: .milk)
    }
}

// MARK: - Private helper for creating dynamic color
extension UIColor {
    private class func dynamicColorIfAvailable(defaultColor: UIColor, darkModeColor: UIColor) -> UIColor {
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
        switch Theme.currentStyle {
        case .light: return defaultColor
        case .dark: return darkModeColor
        }
    }
}
