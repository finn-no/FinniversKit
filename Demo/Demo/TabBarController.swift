import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        updateColors(for: traitCollection, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange), name: .didChangeUserInterfaceStyle, object: nil)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            #if swift(>=5.1)
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                userInterfaceStyleDidChange()
            }
            #endif
        }
    }

    @objc func userInterfaceStyleDidChange() {
        updateColors(for: traitCollection, animated: true)
    }

    func updateColors(for traitCollection: UITraitCollection, animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            let style = State.currentUserInterfaceStyle(for: traitCollection)
            self.tabBar.tintColor = style.foregroundColor
            self.tabBar.barTintColor = style.foregroundColor
        }
    }
}
