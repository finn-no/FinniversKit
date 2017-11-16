//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIFont.registerTroikaFonts()

        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = ViewController<View>()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}

public extension Bundle {

    static var localBundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}
