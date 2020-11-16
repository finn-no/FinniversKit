import UIKit

extension UIView {
    var isHorizontalSizeClassRegular: Bool { traitCollection.horizontalSizeClass == .regular }
}

extension UIViewController {
    var isHorizontalSizeClassRegular: Bool { traitCollection.horizontalSizeClass == .regular }
}

extension UITraitCollection {
    /// This method is intented to be used where `traitCollection` is not available, for example
    /// outside of views or view controllers. Given the idea is to identify if the horizontal size class is regular
    /// similar at the old `UIDevice.isIPad()` then we fallback into that method for iOS 12 and under.
    @objc static var isHorizontalSizeClassRegular: Bool {
        if #available(iOS 13.0, *) {
            return current.horizontalSizeClass == .regular
        } else {
            return UIDevice.isIPad()
        }
    }
}
