//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class LoginEntryViewDemoViewController: DemoViewController<UIView> {
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(tabBarViewController)
        tabBarViewController.didMove(toParent: self)
        view.addSubview(tabBarViewController.view)

        tabBarViewController.view.fillInSuperview()
    }

    private lazy var tabBarViewController: UITabBarController = {
        let tabBar = UITabBarController()
        tabBar.view.translatesAutoresizingMaskIntoConstraints = false
        tabBar.viewControllers = [
            LoginEntryDemoPageViewController(page: .notifications),
            LoginEntryDemoPageViewController(page: .ads),
            LoginEntryDemoPageViewController(page: .messages),
            LoginEntryDemoPageViewController(page: .settings),
        ]
        tabBar.selectedIndex = 3

        return tabBar
    }()
}
