//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit
import Bootstrap

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var navigationController = NavigationController(rootViewController: DemoViewsTableViewController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let userInterfaceStyle = UserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: State.currentUserInterfaceStyleKey))
        let userInterfaceStyleSupport: FinniversKit.UserInterfaceStyleSupport
        if let userInterfaceStyle = userInterfaceStyle {
            userInterfaceStyleSupport = userInterfaceStyle == .dark ? .forceDark : .forceLight
        } else {
            userInterfaceStyleSupport = State.defaultUserInterfaceStyleSupport
        }

        FinniversKit.setup(userInterfaceStyleSupport: userInterfaceStyleSupport)

        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.setWindowUserInterfaceStyle(userInterfaceStyle)
        }
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
