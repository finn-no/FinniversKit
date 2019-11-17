import Foundation

@objc public class Sandbox: NSObject {
    static var bundle: Bundle {
        return Bundle(for: Sandbox.self)
    }

    public static var isDynamicTypeEnabled: Bool = true
}

@objc public extension Bundle {
    static var sandbox: Bundle {
        return Sandbox.bundle
    }
}
