import Foundation

/// Class for referencing the framework bundle
public class TroikaPlaygroundSupport {

    static var bundle: Bundle {
        return Bundle(for: TroikaPlaygroundSupport.self)
    }

    public static func setupPlayground() {
        UIFont.registerTroikaFonts()
    }
}

public extension Bundle {

    static var troikaPlaygroundSupport: Bundle {
        return TroikaPlaygroundSupport.bundle
    }
}
