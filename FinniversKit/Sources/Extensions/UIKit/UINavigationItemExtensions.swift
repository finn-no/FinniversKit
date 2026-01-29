import UIKit

public extension UINavigationItem {
    func configureWithTransparentAppearance() {
        standardAppearance = .transparent
        compactAppearance = .transparent
        scrollEdgeAppearance = .transparent
    }

    func configureWithOpaqueAppearance() {
        standardAppearance = .opaque
        compactAppearance = .opaque
        scrollEdgeAppearance = .opaqueNoShadow
    }

    func configureWithNoShadowAppearance() {
        standardAppearance = UINavigationBar.appearance().standardAppearance.copy()
        standardAppearance?.configureWithNoShadowAppearance()

        compactAppearance = UINavigationBar.appearance().compactAppearance?.copy()
        compactAppearance?.configureWithNoShadowAppearance()

        scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance?.copy()
        scrollEdgeAppearance?.configureWithNoShadowAppearance()
    }

    func configureWithNoShadowAppearance(backgroundColor: UIColor) {
         standardAppearance = UINavigationBar.appearance().standardAppearance.copy()
         standardAppearance?.configureWithNoShadowAppearance(backgroundColor: backgroundColor)

         compactAppearance = UINavigationBar.appearance().compactAppearance?.copy()
         compactAppearance?.configureWithNoShadowAppearance(backgroundColor: backgroundColor)

         scrollEdgeAppearance = UINavigationBar.appearance().scrollEdgeAppearance?.copy()
         scrollEdgeAppearance?.configureWithNoShadowAppearance(backgroundColor: backgroundColor)
     }
}
