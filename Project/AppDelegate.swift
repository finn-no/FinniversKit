//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        let marketViewController = MarketViewController()
        let loginViewController = LoginViewController()
        let emptyScreenViewController = EmptyScreenViewController()
        let marketNavigationController = UINavigationController(rootViewController: marketViewController)
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        let emptyScreenNavigationController = UINavigationController(rootViewController: emptyScreenViewController)

        marketNavigationController.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)
        loginNavigationController.tabBarItem = UITabBarItem(title: "Login", image: nil, tag: 1)
        emptyScreenNavigationController.tabBarItem = UITabBarItem(title: "Empty", image: nil, tag: 2)

        let viewControllerList = [marketNavigationController, loginNavigationController, emptyScreenNavigationController]
        tabBarController.viewControllers = viewControllerList

        return tabBarController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        UIFont.registerTroikaFonts()

        return true
    }
}
