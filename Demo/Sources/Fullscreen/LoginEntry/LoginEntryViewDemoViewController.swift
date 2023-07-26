//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit

class LoginEntryViewDemoViewController: UIViewController, Demoable {
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

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
