//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: DemoViewsTableViewController())
        navigationController.navigationBar.barTintColor = .midnightBackground
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

public extension Bundle {
    static var playgroundBundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}
