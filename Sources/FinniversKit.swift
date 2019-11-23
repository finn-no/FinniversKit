//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Bootstrap
import Foundation

/// Class for referencing the framework bundle
@objc public class FinniversKit: NSObject {
    public enum UserInterfaceStyleSupport {
        @available(iOS 13.0, *)
        case dynamic
        case forceLight
        case forceDark
    }

    public static var userInterfaceStyleSupport: UserInterfaceStyleSupport = .forceLight

    public static func setup(userInterfaceStyleSupport: UserInterfaceStyleSupport) {
        self.userInterfaceStyleSupport = userInterfaceStyleSupport
        Palette.current = .finnPalette
        FontBook.registerFonts()
        FontBook.current = .finnFontBook
    }

    static var bundle: Bundle {
        return Bundle(for: FinniversKit.self)
    }
}

@objc public extension Bundle {
    static var finniversKit: Bundle {
        return FinniversKit.bundle
    }
}

extension FontBook {
    enum FontType: String {
        case light = "FINNTypeWebStrippet-Light"
        case medium = "FINNTypeWebStrippet-Medium"
        case regular = "FINNTypeWebStrippet-Regular"
        case bold = "FINNTypeWebStrippet-Bold"
    }

    static func registerFonts() {
        FontBook.registerFonts(in: Bundle(for: FinniversKit.self), fontNames: [
            FontType.light.rawValue,
            FontType.medium.rawValue,
            FontType.regular.rawValue,
            FontType.bold.rawValue
        ])
    }

    static var finnFontBook: FontBook = FontBook(
        title1: UIFont(name: FontType.medium.rawValue, size: 34)!.scaledFont(forTextStyle: .largeTitle),

        title2: UIFont(name: FontType.light.rawValue, size: 28)!.scaledFont(forTextStyle: .title1),
        title2Strong: UIFont(name: FontType.medium.rawValue, size: 28)!.scaledFont(forTextStyle: .title1),
        title2Bold: UIFont(name: FontType.bold.rawValue, size: 28)!.scaledFont(forTextStyle: .title1),

        title3: UIFont(name: FontType.light.rawValue, size: 22)!.scaledFont(forTextStyle: .title2),
        title3Strong: UIFont(name: FontType.medium.rawValue, size: 22)!.scaledFont(forTextStyle: .title2),
        title3Bold: UIFont(name: FontType.bold.rawValue, size: 22)!.scaledFont(forTextStyle: .title2),

        body: UIFont(name: FontType.light.rawValue, size: 16)!.scaledFont(forTextStyle: .headline),
        bodyRegular: UIFont(name: FontType.regular.rawValue, size: 16)!.scaledFont(forTextStyle: .headline),
        bodyStrong: UIFont(name: FontType.medium.rawValue, size: 16)!.scaledFont(forTextStyle: .headline),
        bodyBold: UIFont(name: FontType.bold.rawValue, size: 16)!.scaledFont(forTextStyle: .headline),

        caption: UIFont(name: FontType.light.rawValue, size: 14)!.scaledFont(forTextStyle: .footnote),
        captionRegular: UIFont(name: FontType.regular.rawValue, size: 14)!.scaledFont(forTextStyle: .footnote),
        captionStrong: UIFont(name: FontType.medium.rawValue, size: 14)!.scaledFont(forTextStyle: .footnote),

        detail: UIFont(name: FontType.regular.rawValue, size: 12)!.scaledFont(forTextStyle: .caption1),
        detailStrong: UIFont(name: FontType.bold.rawValue, size: 12)!.scaledFont(forTextStyle: .caption1)
    )
}
