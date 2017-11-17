//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

extension NSNotification.Name {
    static let InjectionNotification = Notification.Name(rawValue: "INJECTION_BUNDLE_NOTIFICATION")
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, Viewable {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIFont.registerTroikaFonts()
        NotificationCenter.default.addObserver(self, selector: #selector(injected(notification:)), name: Notification.Name.InjectionNotification, object: nil)

        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController<View>()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }

    @objc func injected(notification: NSNotification) {
        guard let subviews = window?.rootViewController?.view.subviews else {
            return
        }

        for subview in subviews {
            subview.removeFromSuperview()
        }

        window?.rootViewController?.viewDidLoad()
    }
}

public extension Bundle {

    static var localBundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}
