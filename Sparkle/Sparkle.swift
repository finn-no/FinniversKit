import Foundation

/// Class for referencing the framework bundle
@objc public class Sparkle: NSObject {
    public enum UserInterfaceStyleSupport {
        @available(iOS 13.0, *)
        case dynamic
        case forceLight
        case forceDark
    }

    static var bundle: Bundle {
        return Bundle(for: Sparkle.self)
    }

    public static var isDynamicTypeEnabled: Bool = true
    public static var userInterfaceStyleSupport: UserInterfaceStyleSupport = .forceLight
}

@objc public extension Bundle {
    static var sparkle: Bundle {
        return Sparkle.bundle
    }
}
