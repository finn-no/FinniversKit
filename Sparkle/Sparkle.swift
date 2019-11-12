import Foundation

@objc public class Sparkle: NSObject {
    static var bundle: Bundle {
        return Bundle(for: Sparkle.self)
    }

    public static var isDynamicTypeEnabled: Bool = true
}

@objc public extension Bundle {
    static var sparkle: Bundle {
        return Sparkle.bundle
    }
}
