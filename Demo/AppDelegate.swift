//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var navigationController: NavigationController = {
        let navigationController = NavigationController(rootViewController: DemoViewsTableViewController())
        return navigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        Theme.currentStyle = UserInterfaceStyle(traitCollection: window!.traitCollection)

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
