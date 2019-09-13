//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var navigationController: NavigationController = {
        let navigationController = NavigationController(rootViewController: DemoViewsTableViewController())
        return navigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            FinniversKit.userInterfaceStyleSupport = .dynamic
        } else {
            let style = UserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: State.currentUserInterfaceStyleKey)) ?? .light
            FinniversKit.userInterfaceStyleSupport = style == .dark ? .forceDark : .forceLight
        }

        window = UIWindow(frame: UIScreen.main.bounds)
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
