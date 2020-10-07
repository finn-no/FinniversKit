//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public enum FontWeight: String {
    case light
    case medium
    case regular
    case bold
}

public protocol FontProvider {
    var title1: UIFont { get }
    var title2: UIFont { get }
    var title3Strong: UIFont { get }
    var title3: UIFont { get }
    var bodyStrong: UIFont { get }
    var bodyRegular: UIFont { get }
    var body: UIFont { get }
    var caption: UIFont { get }
    var captionStrong: UIFont { get }
    var detailStrong: UIFont { get }
    var detail: UIFont { get }
    func font(ofSize size: CGFloat, weight: FontWeight) -> UIFont
}

// MARK: - Default FINN fonts

public struct DefaultFontProvider: FontProvider {
    /// FINNTypeWebStrippet-Medium with a size of 34 scaled for UIFontTextStyle.title1
    /// ## Usage:
    /// - It should only be used one T1 and it should be the first text element that catches the users attention.
    /// - It shall give the user an overview of which page he or she is located.
    /// - This always has the weight Medium.
    public var title1: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.medium.rawValue, size: 34.0)!
        return font.scaledFont(forTextStyle: .largeTitle)
    }

    /// FINNTypeWebStrippet-Light with a size of 28 scaled for UIFontTextStyle.title2
    ///
    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    /// - This always has the weight Light.
    public var title2: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.light.rawValue, size: 28.0)!
        return font.scaledFont(forTextStyle: .title1)
    }

    /// FINNTypeWebStrippet-Medium with a size of 22 scaled for UIFontTextStyle.title3Strong
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Medium.
    public var title3Strong: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.medium.rawValue, size: 22)!
        return font.scaledFont(forTextStyle: .title2)
    }

    /// FINNTypeWebStrippet-Light with a size of 22 scaled for UIFontTextStyle.title3
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Light.
    public var title3: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.light.rawValue, size: 22)!
        return font.scaledFont(forTextStyle: .title2)
    }

    /// FINNTypeWebStrippet-Medium with a size of 16 scaled for UIFontTextStyle.headline
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always bolded (Medium) to differenciate them.
    public var bodyStrong: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.medium.rawValue, size: 16.0)!
        return font.scaledFont(forTextStyle: .headline)
    }

    /// FINNTypeWebStrippet-Regular with a size of 16 scaled for UIFontTextStyle.headline
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always semibolded (Regular) to differenciate them.
    public var bodyRegular: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.regular.rawValue, size: 16.0)!
        return font.scaledFont(forTextStyle: .headline)
    }

    /// FINNTypeWebStrippet-Light with a size of 16 scaled for UIFontTextStyle.body
    ///
    /// ## Usage:
    /// - Regular text below titles is called body text and is weighted Medium.
    public var body: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.light.rawValue, size: 16.0)!
        return font.scaledFont(forTextStyle: .callout)
    }

    /// FINNTypeWebStrippet-Light with a size of 14 scaled for UIFontTextStyle.footnote
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - This is slightly smaller than body text. Weighted Light.
    public var caption: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.light.rawValue, size: 14.0)!
        return font.scaledFont(forTextStyle: .footnote)
    }

    /// FINNTypeWebStrippet-Light with a size of 14 scaled for UIFontTextStyle.footnote
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - Bold version of Caption
    /// - This is slightly smaller than body text. Weighted Medium.
    public var captionStrong: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.medium.rawValue, size: 14.0)!
        return font.scaledFont(forTextStyle: .footnote)
    }

    /// FINNTypeWebStrippet-Bold with a size of 12 scaled for UIFontTextStyle.caption1
    ///
    /// ## Usage:
    /// - Used for small, bold headlines.
    public var detailStrong: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.bold.rawValue, size: 12.0)!
        return font.scaledFont(forTextStyle: .caption1)
    }

    /// FINNTypeWebStrippet-Light with a size of 12 scaled for UIFontTextStyle.caption1
    ///
    /// ## Usage:
    /// - Less important information can be shown as detail text, not for long sentences.
    /// - This is slightly smaller than body text. Weighted Regular.
    /// - The color Stone is prefered in most cases with white background.
    /// - For colored background such as ribbons, the color should be Licorice.
    public var detail: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.regular.rawValue, size: 12.0)!
        return font.scaledFont(forTextStyle: .caption1)
    }

    public func font(ofSize size: CGFloat, weight: FontWeight) -> UIFont {
        switch weight {
        case .light:
            return UIFont(name: FontType.light.rawValue, size: size)!
        case .medium:
            return UIFont(name: FontType.medium.rawValue, size: size)!
        case .regular:
            return UIFont(name: FontType.regular.rawValue, size: size)!
        case .bold:
            return UIFont(name: FontType.bold.rawValue, size: size)!
        }
    }

    private func registerCustomFonts() {
        _ = FontRegistrator.registerCustomFonts
    }
}

// MARK: - FINN Font types

private enum FontType: String {
    case light = "FINNTypeWebStrippet-Light"
    case medium = "FINNTypeWebStrippet-Medium"
    case regular = "FINNTypeWebStrippet-Regular"
    case bold = "FINNTypeWebStrippet-Bold"
}

// https://medium.com/swift-and-ios-writing/a-quick-look-at-gcd-and-swift-3-732bef6e1838
// https://stackoverflow.com/questions/37801407/whither-dispatch-once-in-swift-3/37801408
// Registering fonts, only once instead of each time.
private final class FontRegistrator {
    static let registerCustomFonts = FontRegistrator()
    init() {
        UIFont.registerFont(with: FontType.light.rawValue)
        UIFont.registerFont(with: FontType.medium.rawValue)
        UIFont.registerFont(with: FontType.regular.rawValue)
        UIFont.registerFont(with: FontType.bold.rawValue)
    }
}

// MARK: - Private extensions

private extension UIFont {
    static func registerFont(with filenameString: String) {
        if let bundleURL = Bundle.finniversKit.url(forResource: "FinniversKit", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                registerFontFor(bundle: bundle, forResource: filenameString)
                return
            }
        }

        if let bundleIdentifier = Bundle.finniversKit.bundleIdentifier {
            if let bundle = Bundle(identifier: bundleIdentifier) {
                registerFontFor(bundle: bundle, forResource: filenameString)
            }
        }
    }

    private static func registerFontFor(bundle: Bundle, forResource: String) {
        guard let pathForResourceString = bundle.path(forResource: forResource, ofType: "ttf") else {
            print("UIFont+: Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+: Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+: Failed to register font - data provider could not be loaded.")
            return
        }

        guard let fontRef = CGFont(dataProvider) else {
            print("UIFont+: Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>?
        CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)
    }
}
