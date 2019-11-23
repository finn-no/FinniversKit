//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct FontBook {
    public var title1: UIFont

    public var title2: UIFont
    public var title2Strong: UIFont
    public var title2Bold: UIFont

    public var title3: UIFont
    public var title3Strong: UIFont
    public var title3Bold: UIFont

    public var body: UIFont
    public var bodyRegular: UIFont
    public var bodyStrong: UIFont
    public var bodyBold: UIFont

    public var caption: UIFont
    public var captionRegular: UIFont
    public var captionStrong: UIFont

    public var detail: UIFont
    public var detailStrong: UIFont

    public static var current: FontBook = .default

    public init(title1: UIFont,

                title2: UIFont,
                title2Strong: UIFont,
                title2Bold: UIFont,

                title3: UIFont,
                title3Strong: UIFont,
                title3Bold: UIFont,

                body: UIFont,
                bodyRegular: UIFont,
                bodyStrong: UIFont,
                bodyBold: UIFont,

                caption: UIFont,
                captionRegular: UIFont,
                captionStrong: UIFont,

                detail: UIFont,
                detailStrong: UIFont) {
        self.title1 = title1

        self.title2 = title2
        self.title2Strong = title2Strong
        self.title2Bold = title2Bold

        self.title3 = title3
        self.title3Strong = title3Strong
        self.title3Bold = title3Bold

        self.body = body
        self.bodyRegular = bodyRegular
        self.bodyStrong = bodyStrong
        self.bodyBold = bodyBold

        self.caption = caption
        self.captionRegular = captionRegular
        self.captionStrong = captionStrong

        self.detail = detail
        self.detailStrong = detailStrong
    }

    static var `default`: FontBook {
        FontBook(
            title1: UIFont.systemFont(ofSize: 34, weight: .medium).scaledFont(forTextStyle: .largeTitle),

            title2: UIFont.systemFont(ofSize: 28, weight: .light).scaledFont(forTextStyle: .title1),
            title2Strong: UIFont.systemFont(ofSize: 28, weight: .medium).scaledFont(forTextStyle: .title1),
            title2Bold: UIFont.systemFont(ofSize: 28, weight: .bold).scaledFont(forTextStyle: .title1),

            title3: UIFont.systemFont(ofSize: 22, weight: .light).scaledFont(forTextStyle: .title2),
            title3Strong: UIFont.systemFont(ofSize: 22, weight: .medium).scaledFont(forTextStyle: .title2),
            title3Bold: UIFont.systemFont(ofSize: 22, weight: .bold).scaledFont(forTextStyle: .title2),

            body: UIFont.systemFont(ofSize: 16, weight: .light).scaledFont(forTextStyle: .headline),
            bodyRegular: UIFont.systemFont(ofSize: 16, weight: .regular).scaledFont(forTextStyle: .headline),
            bodyStrong: UIFont.systemFont(ofSize: 16, weight: .medium).scaledFont(forTextStyle: .headline),
            bodyBold: UIFont.systemFont(ofSize: 16, weight: .bold).scaledFont(forTextStyle: .headline),

            caption: UIFont.systemFont(ofSize: 14, weight: .medium).scaledFont(forTextStyle: .footnote),
            captionRegular: UIFont.systemFont(ofSize: 14, weight: .regular).scaledFont(forTextStyle: .footnote),
            captionStrong: UIFont.systemFont(ofSize: 14, weight: .medium).scaledFont(forTextStyle: .footnote),

            detail: UIFont.systemFont(ofSize: 12, weight: .bold).scaledFont(forTextStyle: .caption1),
            detailStrong: UIFont.systemFont(ofSize: 12, weight: .bold).scaledFont(forTextStyle: .caption1))
    }

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
        return FontBook.current.title1
    }

    /// Scaled font for `.title1` text style.
    /// If no font is provided uses `.light` weight system font of size `28`.
    ///
    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    /// - This always has the weight Light.
    static var title2: UIFont {
        return FontBook.current.title2
    }

    /// Scaled font for `.title1` text style.
    /// If no font is provided uses `.bold` weight system font of size `28`.
    ///
    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    /// - This always has the weight Light.
    static var title2Bold: UIFont {
        return FontBook.current.title2Bold
    }

    /// Scaled font for `.title1` text style.
    /// If no font is provided uses `.medium` weight system font of size `28`.
    ///
    /// ## Usage:
    /// - A page can contain multiple T2 to divide content into several sections.
    /// - There should be a lot of space between sections to create a clear distinction on the content.
    /// - This always has the weight Light.
    static var title2Strong: UIFont {
        return FontBook.current.title2Strong
    }

    /// Scaled font for `.title2` text style.
    /// If no font is provided uses `.medium` weight system font of size `22`.
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Medium.
    static var title3Strong: UIFont {
        return FontBook.current.title3Strong
    }

    /// Scaled font for `.title2` text style.
    /// If no font is provided uses `.light` weight system font of size `22`.
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Light.
    static var title3: UIFont {
        return FontBook.current.title3
    }

    /// Scaled font for `.title2` text style.
    /// If no font is provided uses `.bold` weight system font of size `22`.
    ///
    /// ## Usage:
    /// - If a T2 have more sublevels, you can use T3.
    /// - This always has the weight Light.
    static var title3Bold: UIFont {
        return FontBook.current.title3Bold
    }

    /// Scaled font for `.headline` text style.
    /// If no font is provided uses `.bold` weight system font of size `16`.
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always bolded (Medium) to differenciate them.
    static var bodyBold: UIFont {
        return FontBook.current.bodyBold
    }

    /// Scaled font for `.headline` text style.
    /// If no font is provided uses `.medium` weight system font of size `16`.
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always bolded (Medium) to differenciate them.
    static var bodyStrong: UIFont {
        return FontBook.current.bodyStrong
    }

    /// Scaled font for `.headline` text style.
    /// If no font is provided uses `.regular` weight system font of size `16`.
    ///
    /// ## Usage:
    /// - This have the same size as the body text, but is always semibolded (Regular) to differenciate them.
    static var bodyRegular: UIFont {
        return FontBook.current.bodyRegular
    }

    /// Scaled font for `.callout` text style.
    /// If no font is provided uses `.light` weight system font of size `16`.
    ///
    /// ## Usage:
    /// - Regular text below titles is called body text and is weighted Medium.
    static var body: UIFont {
        return FontBook.current.body
    }

    /// Scaled font for `.footnote` text style.
    /// If no font is provided uses `.light` weight system font of size `14`.
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - This is slightly smaller than body text. Weighted Light.
    static var caption: UIFont {
        return FontBook.current.caption
    }

    /// Scaled font for `.footnote` text style.
    /// If no font is provided uses `.medium` weight system font of size `14`.
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - Bold version of Caption
    /// - This is slightly smaller than body text. Weighted Medium.
    static var captionStrong: UIFont {
        return FontBook.current.captionStrong
    }

    /// Scaled font for `.footnote` text style.
    /// If no font is provided uses `.regular` weight system font of size `14`.
    ///
    /// ## Usage:
    /// - Used for short amount of text if neither the Body or Detail is appropriate.
    /// - Bold version of Caption
    /// - This is slightly smaller than body text. Weighted Medium.
    static var captionRegular: UIFont {
        return FontBook.current.captionRegular
    }

    /// Scaled font for `.caption1` text style.
    /// If no font is provided uses `.bold` weight system font of size `12`.
    ///
    /// ## Usage:
    /// - Used for small, bold headlines.
    static var detailStrong: UIFont {
        return FontBook.current.detailStrong
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
        return FontBook.current.detail
    }
}

extension UIFont {
    public func scaledFont(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        if Bootstrap.isDynamicTypeEnabled {
            let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
            return fontMetrics.scaledFont(for: self)
        } else {
            return self
        }
    }
}
