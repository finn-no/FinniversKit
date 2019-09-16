//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let defaultUserInterfaceStyleSupport: FinniversKit.UserInterfaceStyleSupport = {
        if #available(iOS 13.0, *) {
            return .dynamic
        }
        return .forceLight
    }()

    lazy var navigationController: NavigationController = {
        let navigationController = NavigationController(rootViewController: DemoViewsTableViewController())
        return navigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let userInterfaceStyle = UserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: State.currentUserInterfaceStyleKey))
        if let userInterfaceStyle = userInterfaceStyle {
            FinniversKit.userInterfaceStyleSupport = userInterfaceStyle == .dark ? .forceDark : .forceLight
        } else {
            FinniversKit.userInterfaceStyleSupport = defaultUserInterfaceStyleSupport
        }
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

