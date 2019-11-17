import Foundation

@objc public class Bootstrap: NSObject {
    public enum UserInterfaceStyleSupport {
        @available(iOS 13.0, *)
        case dynamic
        case forceLight
        case forceDark
    }

    public static var isDynamicTypeEnabled: Bool = true
    public static var userInterfaceStyleSupport: UserInterfaceStyleSupport = .forceLight
}
