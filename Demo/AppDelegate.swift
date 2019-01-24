//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = DemoViewsTableViewController()
        window?.makeKeyAndVisible()

        if #available(iOS 10.0, *) {
            try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .init(rawValue: 0))
            try? AVAudioSession.sharedInstance().setActive(true)
        }

        return true
    }
}

public extension Bundle {
    static var playgroundBundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}
