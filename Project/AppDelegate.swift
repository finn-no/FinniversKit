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
        let marketNavigationController = UINavigationController(rootViewController: marketViewController)
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)

        marketNavigationController.tabBarItem = UITabBarItem(title: "Home", image: nil, tag: 0)
        loginNavigationController.tabBarItem = UITabBarItem(title: "Login", image: nil, tag: 1)

        let viewControllerList = [marketNavigationController, loginNavigationController]
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
