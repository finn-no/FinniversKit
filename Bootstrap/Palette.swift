public class Palette: NSObject {
    public static let shared = Palette()

    public var bgPrimary: UIColor?
    public var bgSecondary: UIColor?
    public var bgTertiary: UIColor?
    public var bgBottomSheet: UIColor?
    public var bgAlert: UIColor?
    public var bgSuccess: UIColor?
    public var bgCritical: UIColor?
    public var btnPrimary: UIColor?
    public var btnDisabled: UIColor?
    public var btnCritical: UIColor?
    public var textPrimary: UIColor?
    public var textSecondary: UIColor?
    public var textTertiary: UIColor?
    public var textAction: UIColor?
    public var textDisabled: UIColor?
    public var textCritical: UIColor?
    public var accentSecondaryBlue: UIColor?
    public var accentPea: UIColor?
    public var accentToothpaste: UIColor?
    public var textCTADisabled: UIColor?
    public var textToast: UIColor?
    public var tableViewSeparator: UIColor?
    public var decorationSubtle: UIColor?
    public var iconPrimary: UIColor?
    public var iconSecondary: UIColor?
    public var defaultCellSelectedBackgroundColor: UIColor?
}

// MARK: - Semantic colors, dark mode compatible
@objc extension UIColor {
    public class var bgPrimary: UIColor {
        return Palette.shared.bgPrimary ?? dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: UIColor(hex: "#1B1B24"))
    }

    public class var bgSecondary: UIColor {
        return Palette.shared.bgSecondary ?? dynamicColorIfAvailable(defaultColor: .ice, darkModeColor: .darkIce)
    }

    public class var bgTertiary: UIColor {
        return Palette.shared.bgTertiary ?? dynamicColorIfAvailable(defaultColor: .marble, darkModeColor: UIColor(hex: "#13131A"))
    }

    public class var bgBottomSheet: UIColor {
        return Palette.shared.bgBottomSheet ?? dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: .darkIce)
    }

    public class var bgAlert: UIColor {
        return Palette.shared.bgAlert ?? .banana
    }

    public class var bgSuccess: UIColor {
        return Palette.shared.bgSuccess ?? .mint
    }

    public class var bgCritical: UIColor {
        return Palette.shared.bgCritical ?? .salmon
    }

    public class var btnPrimary: UIColor {
        return Palette.shared.btnPrimary ?? dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: UIColor(hex: "#006DFB"))
    }

    public class var btnDisabled: UIColor {
        return Palette.shared.btnDisabled ?? dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public class var btnCritical: UIColor {
        return Palette.shared.btnCritical ?? .cherry
    }

    public class var textPrimary: UIColor {
        return Palette.shared.textPrimary ?? dynamicColorIfAvailable(defaultColor: .licorice, darkModeColor: .milk)
    }

    public class var textSecondary: UIColor {
        return Palette.shared.textSecondary ?? dynamicColorIfAvailable(defaultColor: .stone, darkModeColor: UIColor(hex: "#828699"))
    }

    public class var textTertiary: UIColor {
        return Palette.shared.textTertiary ?? .milk
    }

    public class var textAction: UIColor {
        return Palette.shared.textAction ?? dynamicColorIfAvailable(defaultColor: .primaryBlue, darkModeColor: UIColor(hex: "#3F8BFF"))
    }

    public class var textDisabled: UIColor {
        return Palette.shared.textDisabled ?? dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public class var textCritical: UIColor {
        return Palette.shared.textCritical ?? dynamicColorIfAvailable(defaultColor: .cherry, darkModeColor: .watermelon)
    }

    public class var textCTADisabled: UIColor {
        return Palette.shared.textCTADisabled ?? dynamicColorIfAvailable(defaultColor: .licorice, darkModeColor: UIColor(hex: "#828699"))
    }

    public class var textToast: UIColor {
        return Palette.shared.textToast ?? .licorice
    }

    public class var tableViewSeparator: UIColor {
        return Palette.shared.tableViewSeparator ?? dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }

    public class var decorationSubtle: UIColor {
        return Palette.shared.decorationSubtle ?? .btnDisabled
    }

    public class var iconPrimary: UIColor {
        return Palette.shared.iconPrimary ?? .textPrimary
    }

    public class var iconSecondary: UIColor {
        return Palette.shared.iconSecondary ?? .textTertiary
    }

    public class var defaultCellSelectedBackgroundColor: UIColor {
        let lightSelectedColor = UIColor(r: 230, g: 235, b: 242)!
        return Palette.shared.defaultCellSelectedBackgroundColor ??  dynamicColorIfAvailable(defaultColor: lightSelectedColor, darkModeColor: lightSelectedColor.withAlphaComponent(0.4))
    }

    public class var dimmingColor: UIColor {
        return UIColor.black.withAlphaComponent(0.4) //DARK
    }
}

// MARK: - FINN UIColors
@objc extension UIColor {
    class var ice: UIColor {
        return UIColor(r: 241, g: 249, b: 255)!
    }

    class var milk: UIColor {
        return UIColor(r: 255, g: 255, b: 255)!
    }

    class var licorice: UIColor {
        return UIColor(r: 71, g: 68, b: 69)!
    }

    class var primaryBlue: UIColor {
        return UIColor(r: 0, g: 99, b: 251)!
    }

    class var secondaryBlue: UIColor {
        return UIColor(r: 6, g: 190, b: 251)!
    }

    class var stone: UIColor {
        return UIColor(r: 118, g: 118, b: 118)!
    }

    class var sardine: UIColor {
        return UIColor(r: 195, g: 204, b: 217)!
    }

    class var darkSardine: UIColor {
        return UIColor(hex: "434359")
    }

    class var salmon: UIColor {
        return UIColor(r: 255, g: 239, b: 239)!
    }

    class var mint: UIColor {
        return UIColor(r: 204, g: 255, b: 236)!
    }

    class var toothPaste: UIColor {
        return UIColor(r: 182, g: 240, b: 255)!
    }

    class var banana: UIColor {
        return UIColor(r: 255, g: 245, b: 200)!
    }

    class var cherry: UIColor {
        return UIColor(r: 217, g: 39, b: 10)!
    }

    class var watermelon: UIColor {
        return UIColor(r: 255, g: 88, b: 68)!
    }

    class var pea: UIColor {
        return UIColor(r: 46, g: 230, b: 159)!
    }

    class var marble: UIColor {
        return UIColor(r: 246, g: 248, b: 251)!
    }

    class var midnightBackground: UIColor {
        return UIColor(hex: "1D1D26")
    }

    class var midnightSectionHeader: UIColor {
        return UIColor(hex: "585E8A")
    }

    class var midnightSectionSeparator: UIColor {
        return UIColor(hex: "34343E")
    }

    class var darkIce: UIColor {
        return UIColor(hex: "#262633")
    }

    // swiftlint:disable:next identifier_name
    public convenience init?(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }

    /// Base initializer, it creates an instance of `UIColor` using an HEX string.
    ///
    /// - Parameter hex: The base HEX string to create the color.
    public convenience init(hex: String) {
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
}

// MARK: - Private helper for creating dynamic color
extension UIColor {
    public class func dynamicColorIfAvailable(defaultColor: UIColor, darkModeColor: UIColor) -> UIColor {
        switch Bootstrap.userInterfaceStyleSupport {
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
