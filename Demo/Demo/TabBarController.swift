import FinniversKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        tabBar.tintColor = .foregroundColor
        tabBar.barTintColor = .foregroundColor
    }
}
