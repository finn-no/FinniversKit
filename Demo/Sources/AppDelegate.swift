//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit
import DemoKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let demoViewController = DemoKitViewController(demoGroups: [
            DNA.self,
            Cells.self,
            Components.self,
            Recycling.self,
            SwiftUIDemo.self,
            Fullscreen.self,
        ])
        window?.rootViewController = UINavigationController(rootViewController: demoViewController)

        window?.makeKeyAndVisible()

        linkReveal()

        return true
    }
}

public extension Bundle {
    static var playgroundBundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}

// MARK: - Reveal integration

extension AppDelegate {
    private func linkReveal() {
        #if targetEnvironment(simulator)
        guard !TestCheck.isTesting else { return }

        // `NSHomeDirectory()` provides the path for the app/user within the simulator so we need to shorten it.
        let userHomeDir = NSHomeDirectory().components(separatedBy: "/").prefix(3).joined(separator: "/")
        let revealLibraryPath = "\(userHomeDir)/Library/Application Support/Reveal/RevealServer/RevealServer.xcframework/ios-arm64_x86_64-simulator/RevealServer.framework/RevealServer"
        guard FileManager.default.fileExists(atPath: revealLibraryPath) else {
            print("👓❌ Unable to link Reveal. File not found:\n'\(revealLibraryPath)'")
            return
        }

        let revealPathPointer = strdup(revealLibraryPath)
        defer { free(revealPathPointer) }
        let result = dlopen(revealPathPointer, RTLD_NOW)
        if result == nil {
            print("👓❌ Unable to link Reveal. Error code: \(errno)")
        } else {
            print("👓✅ Successfully loaded Reveal server library")
        }
        #endif
    }
}
