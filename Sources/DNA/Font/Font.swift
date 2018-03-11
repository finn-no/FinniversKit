//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

enum FontType: String {
    case light = "FINNTypeWebStrippet-Light"
    case medium = "FINNTypeWebStrippet-Medium"
    case regular = "FINNTypeWebStrippet-Regular"
    case bold = "FINNTypeWebStrippet-Bold"
}

public extension UIFont {
    public static var title1: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.medium.rawValue, size: 36.0)!
        return font.scaledFont(forTextStyle: .title1)
    }

    public static var title2: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.light.rawValue, size: 28.0)!
        return font.scaledFont(forTextStyle: .title2)
    }

    public static var title3: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.light.rawValue, size: 22.5)!
        return font.scaledFont(forTextStyle: .title3)
    }

    public static var title4: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.medium.rawValue, size: 18.0)!
        return font.scaledFont(forTextStyle: .headline)
    }

    public static var title5: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.medium.rawValue, size: 14.0)!
        return font.scaledFont(forTextStyle: .callout)
    }

    public static var body: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.light.rawValue, size: 18.0)!
        return font.scaledFont(forTextStyle: .body)
    }

    public static var detail: UIFont {
        registerCustomFonts()

        let font = UIFont(name: FontType.light.rawValue, size: 14.0)!
        return font.scaledFont(forTextStyle: .footnote)
    }

    func scaledFont(forTextStyle textStyle: UIFontTextStyle) -> UIFont {
        if #available(iOS 11.0, *) {
            let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
            return fontMetrics.scaledFont(for: self)
        } else {
            return self
        }
    }
}

extension UIFont {
    static func registerFont(with filenameString: String) {
        if let bundleURL = Bundle(for: FinniversKit.self).url(forResource: "FinniversKit", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                registerFontFor(bundle: bundle, forResource: filenameString)
                return
            }
        }

        if let bundleIdentifier = Bundle(for: FinniversKit.self).bundleIdentifier {
            if let bundle = Bundle(identifier: bundleIdentifier) {
                registerFontFor(bundle: bundle, forResource: filenameString)
            }
        }
    }

    private static func registerFontFor(bundle: Bundle, forResource: String) {
        guard let pathForResourceString = bundle.path(forResource: forResource, ofType: "ttf") else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }

        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }

        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }

        guard let fontRef = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }

        var errorRef: Unmanaged<CFError>?
        if CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }

    private static func registerCustomFonts() {
        _ = FontRegistrator.registerCustomFonts
    }
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
