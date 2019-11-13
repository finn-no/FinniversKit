//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit
import Sparkle

enum FontType: String {
    case light = "FINNTypeWebStrippet-Light"
    case medium = "FINNTypeWebStrippet-Medium"
    case regular = "FINNTypeWebStrippet-Regular"
    case bold = "FINNTypeWebStrippet-Bold"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var navigationController: NavigationController = {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        let color = SparkleItem(title: "Color", viewController: vc)
        let font = SparkleItem(title: "Font", viewController: vc)
        let dna = SparkleSection(title: "DNA", items: [color, font])
        let c1 = SparkleItem(title: "Component 1", viewController: vc)
        let c2 = SparkleItem(title: "Component 2", viewController: vc)
        let components = SparkleSection(title: "Components", items: [c1, c2])
        let demoViews = DemoViewsTableViewController(sections: [dna, components])
        let navigationController = NavigationController(rootViewController: demoViews)
        return navigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerFonts()

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

    func registerFonts() {
        FontBook.registerFonts(in: Bundle(for: AppDelegate.self), fontNames: [
            FontType.light.rawValue,
            FontType.medium.rawValue,
            FontType.regular.rawValue,
            FontType.bold.rawValue
            ])

        FontBook.shared.title1 = UIFont(name: FontType.medium.rawValue, size: 34)!

        FontBook.shared.title2 = UIFont(name: FontType.light.rawValue, size: 28)!
        FontBook.shared.title2Strong = UIFont(name: FontType.medium.rawValue, size: 28)!
        FontBook.shared.title2Bold = UIFont(name: FontType.bold.rawValue, size: 28)!

        FontBook.shared.title3 = UIFont(name: FontType.light.rawValue, size: 22)!
        FontBook.shared.title3Strong = UIFont(name: FontType.medium.rawValue, size: 22)!
        FontBook.shared.title3Bold = UIFont(name: FontType.bold.rawValue, size: 22)!

        FontBook.shared.body = UIFont(name: FontType.light.rawValue, size: 16)!
        FontBook.shared.bodyRegular = UIFont(name: FontType.regular.rawValue, size: 16)!
        FontBook.shared.bodyStrong = UIFont(name: FontType.medium.rawValue, size: 16)!
        FontBook.shared.bodyBold = UIFont(name: FontType.bold.rawValue, size: 16)!

        FontBook.shared.caption = UIFont(name: FontType.light.rawValue, size: 14)!
        FontBook.shared.captionRegular = UIFont(name: FontType.regular.rawValue, size: 14)!
        FontBook.shared.captionStrong = UIFont(name: FontType.medium.rawValue, size: 14)!

        FontBook.shared.detail = UIFont(name: FontType.regular.rawValue, size: 12)!
        FontBook.shared.detailStrong = UIFont(name: FontType.bold.rawValue, size: 12)!
    }
}

public extension Bundle {
    static var playgroundBundle: Bundle {
        return Bundle(for: AppDelegate.self)
    }
}
