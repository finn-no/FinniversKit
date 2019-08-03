//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var hairlineView: UIView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let navigationController = UINavigationController(rootViewController: DemoViewsTableViewController())
        navigationController.navigationBar.isTranslucent = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        updateColors(animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(userInterfaceStyleDidChange(_:)), name: .didChangeUserInterfaceStyle, object: nil)

        return true
    }
}

private extension AppDelegate {
    @objc func userInterfaceStyleDidChange(_ userInterfaceStyle: UserInterfaceStyle) {
        updateColors(animated: true)
    }

    func updateColors(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) {
            let separatorColor: UIColor
            let barTintColor: UIColor
            let tintColor: UIColor
            let barStyle: UIBarStyle
            switch State.currentUserInterfaceStyle {
            case .light:
                separatorColor = .sardine
                barTintColor = .milk
                tintColor = .primaryBlue
                barStyle = .default
            case .dark:
                separatorColor = .midnightSectionSeparator
                barTintColor = .midnightBackground
                tintColor = .secondaryBlue
                barStyle = .black
            }

            if let navigationController = self.window?.rootViewController as? UINavigationController {
                self.setBottomBorderColor(navigationBar: navigationController.navigationBar, color: separatorColor, height: 0.5)
                navigationController.navigationBar.barTintColor = barTintColor
                navigationController.navigationBar.tintColor = tintColor
                navigationController.navigationBar.barStyle = barStyle
                navigationController.navigationBar.layoutIfNeeded()
            }
        }
    }

    func setBottomBorderColor(navigationBar: UINavigationBar, color: UIColor, height: CGFloat) {
        if hairlineView == nil {
            let bottomBorderRect = CGRect(x: 0, y: navigationBar.frame.height, width: navigationBar.frame.width, height: height)
            let view = UIView(frame: bottomBorderRect)
            navigationBar.addSubview(view)
            hairlineView = view
        }

        hairlineView?.backgroundColor = color
    }
}

public extension Bundle {
    static var playgroundBundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}
