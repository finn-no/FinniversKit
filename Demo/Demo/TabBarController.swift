import FinniversKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        updateColors(for: traitCollection)
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
        updateColors(for: traitCollection)
    }

    func updateColors(for traitCollection: UITraitCollection) {
        let style = UserInterfaceStyle(traitCollection: traitCollection)
        self.tabBar.tintColor = style.foregroundColor
        self.tabBar.barTintColor = style.foregroundColor
    }
}
