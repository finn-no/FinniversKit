//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit
import Sandbox

enum FontType: String {
    case light = "FINNTypeWebStrippet-Light"
    case medium = "FINNTypeWebStrippet-Medium"
    case regular = "FINNTypeWebStrippet-Regular"
    case bold = "FINNTypeWebStrippet-Bold"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    lazy var sections: [SandboxSection] = {
        let dnaItems = DnaDemoViews.items.map { SandboxItem(title: $0.rawValue, viewController: $0.viewController) }
        let dna = SandboxSection(title: "DNA", items: dnaItems)

        let componentItems = ComponentDemoViews.items.map { SandboxItem(title: $0.rawValue, viewController: $0.viewController) }
        let components = SandboxSection(title: "Components", items: componentItems)

        let cellItems = CellsDemoViews.items.map { SandboxItem(title: $0.rawValue, viewController: $0.viewController) }
        let cells = SandboxSection(title: "Cells", items: cellItems)

        let fullscreenItems = FullscreenDemoViews.items.map { SandboxItem(title: $0.rawValue, viewController: $0.viewController) }
        let fullscreen = SandboxSection(title: "Fullscreen", items: fullscreenItems)

        let recyclingItems = RecyclingDemoViews.items.map { SandboxItem(title: $0.rawValue, viewController: $0.viewController) }
        let recycling = SandboxSection(title: "Recycling", items: fullscreenItems)

        return [dna, components, cells, fullscreen, recycling]
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerFonts()

        let userInterfaceStyle = UserInterfaceStyle(rawValue: UserDefaults.standard.integer(forKey: SandboxState.currentUserInterfaceStyleKey))
        if let userInterfaceStyle = userInterfaceStyle {
            FinniversKit.userInterfaceStyleSupport = userInterfaceStyle == .dark ? .forceDark : .forceLight
        } else {
            switch SandboxState.defaultUserInterfaceStyleSupport {
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
        let sandboxViewController = SandboxViewController(sections: sections)
        window?.rootViewController = NavigationController(rootViewController: sandboxViewController)
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
