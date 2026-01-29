import UIKit
import Warp

public extension UINavigationBarAppearance {
    func configureWithNoShadowAppearance() {
        configureWithTransparentBackground()
        backgroundColor = Warp.UIToken.background
    }

    func configureWithNoShadowAppearance(backgroundColor: UIColor) {
         configureWithTransparentBackground()
         self.backgroundColor = backgroundColor
     }

    static var opaque: UINavigationBarAppearance {
        let appearance = UINavigationBar.appearance().standardAppearance.copy()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Warp.UIToken.background
        return appearance
    }

    static var opaqueNoShadow: UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance.opaque
        appearance.shadowColor = nil
        return appearance
    }

    static var transparent: UINavigationBarAppearance {
        let appearance = UINavigationBar.appearance().standardAppearance.copy()
        appearance.configureWithTransparentBackground()
        return appearance
    }
}
