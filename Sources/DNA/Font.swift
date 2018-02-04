//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension UIFont {
    public static var title1: UIFont {
        let font = UIFont(name: "FINNTypeWebStrippet-Medium", size: 36.0)!

        return font.scaledFont(forTextStyle: .title1)
    }

    public static var title2: UIFont {
        let font = UIFont(name: "FINNTypeWebStrippet-Light", size: 28.0)!

        return font.scaledFont(forTextStyle: .title2)
    }

    public static var title3: UIFont {
        let font = UIFont(name: "FINNTypeWebStrippet-Light", size: 22.5)!

        return font.scaledFont(forTextStyle: .title3)
    }

    public static var title4: UIFont {
        let font = UIFont(name: "FINNTypeWebStrippet-Medium", size: 18.0)!

        return font.scaledFont(forTextStyle: .headline)
    }

    public static var title5: UIFont {
        let font = UIFont(name: "FINNTypeWebStrippet-Medium", size: 14.0)!

        return font.scaledFont(forTextStyle: .callout)
    }

    public static var body: UIFont {
        let font = UIFont(name: "FINNTypeWebStrippet-Light", size: 18.0)!

        return font.scaledFont(forTextStyle: .body)
    }

    public static var detail: UIFont {
        let font = UIFont(name: "FINNTypeWebStrippet-Light", size: 14.0)!

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
    static func registerFont(with filenameString: String, bundleIdentifierString: String) {
        guard let bundle = Bundle(identifier: bundleIdentifierString) else {
            print("UIFont+:  Failed to register font - bundle identifier invalid.")
            return
        }

        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: "ttf") else {
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

    public static func registerTroikaFonts() {
        registerFont(with: "FINNTypeWebStrippet-Light", bundleIdentifierString: "no.finn.Troika")
        registerFont(with: "FINNTypeWebStrippet-Medium", bundleIdentifierString: "no.finn.Troika")
        registerFont(with: "FINNTypeWebStrippet-Regular", bundleIdentifierString: "no.finn.Troika")
        registerFont(with: "FINNTypeWebStrippet-Bold", bundleIdentifierString: "no.finn.Troika")
    }
}
