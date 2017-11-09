//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        let marketViewController = MarketViewController()
        let loginViewController = LoginViewController()

        navigationController.addChildViewController(loginViewController)
        tabBarController.setViewControllers([navigationController], animated: false)

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
