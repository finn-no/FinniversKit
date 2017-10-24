import UIKit

public extension UIFont {

    public static var t1: UIFont {
        return UIFont(name: "FINNTypeWebStrippet-Medium", size: 36.0)!
    }

    public static var t2: UIFont {
        return UIFont(name: "FINNTypeWebStrippet-Light", size: 28.0)!
    }

    public static var t3: UIFont {
        return UIFont(name: "FINNTypeWebStrippet-Light", size: 22.5)!
    }

    public static var t4: UIFont {
        return UIFont(name: "FINNTypeWebStrippet-Medium", size: 18.0)!
    }

    public static var t5: UIFont {
        return UIFont(name: "FINNTypeWebStrippet-Medium", size: 14.0)!
    }

    public static var body: UIFont {
        return UIFont(name: "FINNTypeWebStrippet-Light", size: 18.0)!
    }

    public static var detail: UIFont {
        return UIFont(name: "FINNTypeWebStrippet-Light", size: 14.0)!
    }
}

extension UIFont {

    public static func registerFont(with filenameString: String, bundleIdentifierString: String) {
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
