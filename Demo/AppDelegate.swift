//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit
import Sparkle

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var navigationController = NavigationController(rootViewController: DemoViewsTableViewController())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let userInterfaceStyle = UserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: SparkleState.currentUserInterfaceStyleKey))
        if let userInterfaceStyle = userInterfaceStyle {
            FinniversKit.userInterfaceStyleSupport = userInterfaceStyle == .dark ? .forceDark : .forceLight
        } else {
            switch SparkleState.defaultUserInterfaceStyleSupport {
            case .dynamic:
                if #available(iOS 13.0, *) {
                    FinniversKit.userInterfaceStyleSupport = .dynamic
                } else {
                    break
                }
            case .forceDark:
                FinniversKit.userInterfaceStyleSupport = .forceDark
            case .forceLight:
                FinniversKit.userInterfaceStyleSupport = .forceLight
            }
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
