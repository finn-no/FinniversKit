//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public class FontBook: NSObject {
    public static let shared = FontBook()

    public var title1: UIFont?
    public var title2: UIFont?
    public var title2Strong: UIFont?
    public var title2Bold: UIFont?
    public var title3Strong: UIFont?
    public var title3: UIFont?
    public var title3Bold: UIFont?
    public var bodyStrong: UIFont?
    public var bodyRegular: UIFont?
    public var body: UIFont?
    public var bodyBold: UIFont?
    public var caption: UIFont?
    public var captionStrong: UIFont?
    public var captionRegular: UIFont?
    public var detail: UIFont?
    public var detailStrong: UIFont?

    public static func registerFonts(in bundle: Bundle, fontNames: [String]) {
        for fontName in fontNames {
            registerFontFor(bundle: bundle, forResource: fontName)
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

@objc public extension UIFont {
    /// Scaled font for `.largeTitle` text style.
    /// If no font is provided uses `.medium` weight system font of size `34`.
    ///
    /// ## Usage:
    /// - It should only be used one T1 and it should be the first text element that catches the users attention.
    /// - It shall give the user an overview of which page he or she is located.
    /// - This always has the weight Medium.
    static var title1: UIFont {
        let font = FontBook.shared.title1 ?? UIFont.systemFont(ofSize: 34, weight: .medium)
        return font.scaledFont(forTextStyle: .largeTitle)
    }

    /// Scaled font for `.title1` text style.
    /// If no font is provided uses `.light` weight system font of size `28`.
    ///
    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    /// - This always has the weight Light.
    static var title2: UIFont {
        let font = FontBook.shared.title2 ?? UIFont.systemFont(ofSize: 28, weight: .light)
        return font.scaledFont(forTextStyle: .title1)
    }

    /// Scaled font for `.title1` text style.
    /// If no font is provided uses `.bold` weight system font of size `28`.
    ///
    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    /// - This always has the weight Light.
    static var title2Bold: UIFont {
        let font = FontBook.shared.title2Bold ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        return font.scaledFont(forTextStyle: .title1)
    }

    /// Scaled font for `.title1` text style.
    /// If no font is provided uses `.medium` weight system font of size `28`.
    ///
    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    /// - This always has the weight Light.
    static var title2Strong: UIFont {
        let font = FontBook.shared.title2Strong ?? UIFont.systemFont(ofSize: 28, weight: .medium)
        return font.scaledFont(forTextStyle: .title1)
    }

    /// Scaled font for `.title2` text style.
    /// If no font is provided uses `.medium` weight system font of size `22`.
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Medium.
    static var title3Strong: UIFont {
        let font = FontBook.shared.title3Strong ?? UIFont.systemFont(ofSize: 22, weight: .medium)
        return font.scaledFont(forTextStyle: .title2)
    }

    /// Scaled font for `.title2` text style.
    /// If no font is provided uses `.light` weight system font of size `22`.
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Light.
    static var title3: UIFont {
        let font = FontBook.shared.title3 ?? UIFont.systemFont(ofSize: 22, weight: .light)
        return font.scaledFont(forTextStyle: .title2)
    }

    /// Scaled font for `.title2` text style.
    /// If no font is provided uses `.bold` weight system font of size `22`.
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Light.
    static var title3Bold: UIFont {
        let font = FontBook.shared.title3Bold ?? UIFont.systemFont(ofSize: 22, weight: .bold)
        return font.scaledFont(forTextStyle: .title2)
    }

    /// Scaled font for `.headline` text style.
    /// If no font is provided uses `.bold` weight system font of size `16`.
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always bolded (Medium) to differenciate them.
    static var bodyBold: UIFont {
        let font = FontBook.shared.bodyBold ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        return font.scaledFont(forTextStyle: .headline)
    }

    /// Scaled font for `.headline` text style.
    /// If no font is provided uses `.medium` weight system font of size `16`.
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always bolded (Medium) to differenciate them.
    static var bodyStrong: UIFont {
        let font = FontBook.shared.bodyStrong ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        return font.scaledFont(forTextStyle: .headline)
    }

    /// Scaled font for `.headline` text style.
    /// If no font is provided uses `.regular` weight system font of size `16`.
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always semibolded (Regular) to differenciate them.
    static var bodyRegular: UIFont {
        let font = FontBook.shared.bodyRegular ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        return font.scaledFont(forTextStyle: .headline)
    }

    /// Scaled font for `.callout` text style.
    /// If no font is provided uses `.light` weight system font of size `16`.
    ///
    /// ## Usage:
    /// - Regular text below titles is called body text and is weighted Medium.
    static var body: UIFont {
        let font = FontBook.shared.body ?? UIFont.systemFont(ofSize: 16, weight: .light)
        return font.scaledFont(forTextStyle: .callout)
    }

    /// Scaled font for `.footnote` text style.
    /// If no font is provided uses `.light` weight system font of size `14`.
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - This is slightly smaller than body text. Weighted Light.
    static var caption: UIFont {
        let font = FontBook.shared.caption ?? UIFont.systemFont(ofSize: 14, weight: .light)
        return font.scaledFont(forTextStyle: .footnote)
    }

    /// Scaled font for `.footnote` text style.
    /// If no font is provided uses `.medium` weight system font of size `14`.
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - Bold version of Caption
    /// - This is slightly smaller than body text. Weighted Medium.
    static var captionStrong: UIFont {
        let font = FontBook.shared.captionStrong ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        return font.scaledFont(forTextStyle: .footnote)
    }

    /// Scaled font for `.footnote` text style.
    /// If no font is provided uses `.regular` weight system font of size `14`.
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - Bold version of Caption
    /// - This is slightly smaller than body text. Weighted Medium.
    static var captionRegular: UIFont {
        let font = FontBook.shared.captionRegular ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        return font.scaledFont(forTextStyle: .footnote)
    }

    /// Scaled font for `.caption1` text style.
    /// If no font is provided uses `.bold` weight system font of size `12`.
    ///
    /// ## Usage:
    /// - Used for small, bold headlines.
    static var detailStrong: UIFont {
        let font = FontBook.shared.detailStrong ?? UIFont.systemFont(ofSize: 12, weight: .bold)
        return font.scaledFont(forTextStyle: .caption1)
    }

    /// Scaled font for `.caption1` text style.
    /// If no font is provided uses `.regular` weight system font of size `12`.
    ///
    /// ## Usage:
    /// - Less important information can be shown as detail text, not for long sentences.
    /// - This is slightly smaller than body text. Weighted Regular.
    /// - The color Stone is prefered in most cases with white background.
    /// - For colored background such as ribbons, the color should be Licorice.
    static var detail: UIFont {
        let font = FontBook.shared.detail ?? UIFont.systemFont(ofSize: 12, weight: .regular)
        return font.scaledFont(forTextStyle: .caption1)
    }

    func scaledFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        if Bootstrap.isDynamicTypeEnabled {
            let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
            return fontMetrics.scaledFont(for: self)
        } else {
            return self
        }
    }
}
