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
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.setBottomBorderColor(color: .sardine, height: 0.5)
        updateColors()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange(_:)), name: .DidChangeUserInterfaceStyle, object: nil)

        return true
    }

    @objc func userInterfaceStyleDidChange(_ userInterfaceStyle: UserInterfaceStyle) {
        updateColors()
    }

    func updateColors() {
        let barTintColor: UIColor
        let tintColor: UIColor
        let barStyle: UIBarStyle
        switch State.currentUserInterfaceStyle {
        case .light:
            barTintColor = .milk
            tintColor = .primaryBlue
            barStyle = .default
        case .dark:
            barTintColor = .midnightBackground
            tintColor = .secondaryBlue
            barStyle = .black
        }
        
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.navigationBar.barTintColor = barTintColor
            navigationController.navigationBar.tintColor = tintColor
            navigationController.navigationBar.barStyle = barStyle
        }
    }
}

public extension Bundle {
    static var playgroundBundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}

extension UINavigationBar {
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
