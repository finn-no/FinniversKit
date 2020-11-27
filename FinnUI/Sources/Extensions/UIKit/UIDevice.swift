import UIKit.UIDevice

// MARK: - UIDevice

extension UIDevice {
    class func isIPad() -> Bool {
        current.userInterfaceIdiom == .pad
    }
}
