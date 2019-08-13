import FinniversKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        updateColors(for: traitCollection)
    }

    func updateColors(for traitCollection: UITraitCollection) {
        self.tabBar.tintColor = .foregroundColor
        self.tabBar.barTintColor = .foregroundColor
    }
}
