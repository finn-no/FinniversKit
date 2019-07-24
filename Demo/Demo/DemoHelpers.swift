//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit
import UIKit

enum TabletDisplayMode {
    case master
    case detail
    case fullscreen
}

public struct ContainmentOptions: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let navigationController = ContainmentOptions(rawValue: 2 << 0)
    public static let tabBarController = ContainmentOptions(rawValue: 2 << 1)
    public static let bottomSheet = ContainmentOptions(rawValue: 2 << 2)
    public static let all: ContainmentOptions = [.navigationController, .tabBarController, .bottomSheet]
    public static let none = ContainmentOptions(rawValue: 2 << 3)

    /// Attaches a navigation bar, a tab bar or both depending on what is returned here.
    /// If you return nil the screen will have no containers.
    /// Or replace `return nil` with `self = .allCases`, `self = .navigationController` or `self = .tabBarController`
    ///
    /// - Parameter indexPath: The component's index path
    // swiftlint:disable:next cyclomatic_complexity
    init?(indexPath: IndexPath) {
        let sectionType = Sections.for(indexPath)
        switch sectionType {
        case .dna:
            guard let screens = DnaViews.allCases[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            default: return nil
            }
        case .components:
            guard let screens = ComponentViews.allCases[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            case .bannerTransparency:
                self = .bottomSheet
            default: return nil
            }
        case .cells:
            guard let screens = Cells.allCases[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            default: return nil
            }
        case .recycling:
            guard let screens = RecyclingViews.allCases[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            case .favoriteFoldersListView:
                self = .bottomSheet
            default: return nil
            }
        case .fullscreen:
            guard let screens = FullscreenViews.allCases[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            case .consentToggleView:
                self = [.navigationController, .tabBarController]
            case .consentActionView:
                self = [.navigationController, .tabBarController]
            case .addressView:
                self = [.navigationController, .tabBarController]
            default: return nil
            }
        }
    }
}

enum Sections: String, CaseIterable {
    case dna
    case components
    case cells
    case recycling
    case fullscreen

    var numberOfItems: Int {
        switch self {
        case .dna:
            return DnaViews.allCases.count
        case .components:
            return ComponentViews.allCases.count
        case .cells:
            return Cells.allCases.count
        case .recycling:
            return RecyclingViews.allCases.count
        case .fullscreen:
            return FullscreenViews.allCases.count
        }
    }

    static func formattedName(for section: Int) -> String {
        let section = Sections.allCases[section]
        let rawClassName = section.rawValue
        return rawClassName
    }

    static func formattedName(for indexPath: IndexPath) -> String {
        let section = Sections.allCases[indexPath.section]
        var rawClassName: String
        switch section {
        case .dna:
            rawClassName = DnaViews.allCases[indexPath.row].rawValue
        case .components:
            rawClassName = ComponentViews.allCases[indexPath.row].rawValue
        case .cells:
            rawClassName = Cells.allCases[indexPath.row].rawValue
        case .recycling:
            rawClassName = RecyclingViews.allCases[indexPath.row].rawValue
        case .fullscreen:
            rawClassName = FullscreenViews.allCases[indexPath.row].rawValue
        }

        return rawClassName.capitalizingFirstLetter
    }

    static func `for`(_ indexPath: IndexPath) -> Sections {
        return Sections.allCases[indexPath.section]
    }

    // swiftlint:disable:next cyclomatic_complexity
    static func viewController(for indexPath: IndexPath) -> UIViewController? {
        guard let section = Sections.allCases[safe: indexPath.section] else {
            return nil
        }
        var viewController: UIViewController?
        switch section {
        case .dna:
            let selectedView = DnaViews.allCases[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .components:
            let selectedView = ComponentViews.allCases[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .cells:
            let selectedView = Cells.allCases[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .recycling:
            let selectedView = RecyclingViews.allCases[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .fullscreen:
            let selectedView = FullscreenViews.allCases[safe: indexPath.row]
            viewController = selectedView?.viewController
        }

        let sectionType = Sections.for(indexPath)
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            switch sectionType.tabletDisplayMode {
            case .master:
                if let unwrappedViewController = viewController {
                    viewController = SplitViewController(masterViewController: unwrappedViewController)
                }
            case .detail:
                if let unwrappedViewController = viewController {
                    viewController = SplitViewController(detailViewController: unwrappedViewController)
                }
            default:
                break
            }
        default:
            break
        }

        let shouldIncludeNavigationController = ContainmentOptions(indexPath: indexPath)?.contains(.navigationController) ?? false
        if shouldIncludeNavigationController {
            if let unwrappedViewController = viewController {
                viewController = UINavigationController(rootViewController: unwrappedViewController)
            }
        }

        let shouldIncludeTabBarController = ContainmentOptions(indexPath: indexPath)?.contains(.tabBarController) ?? false
        if shouldIncludeTabBarController {
            let tabBarController = UITabBarController()
            if let unwrappedViewController = viewController {
                tabBarController.viewControllers = [unwrappedViewController]
                viewController = tabBarController
            }
        }

        let shouldPresentInBottomSheet = ContainmentOptions(indexPath: indexPath)?.contains(.bottomSheet) ?? false
        if shouldPresentInBottomSheet {
            if let unwrappedViewController = viewController {
                let bottomSheet = BottomSheet(rootViewController: unwrappedViewController)
                viewController = bottomSheet
            }
        }

        return viewController
    }

    var tabletDisplayMode: TabletDisplayMode {
        switch self {
        case .dna, .components, .fullscreen, .cells:
            return .fullscreen
        case .recycling:
            return .fullscreen
        }
    }
}

extension Array {
    /// Returns nil if index < count
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : .none
    }
}

extension Foundation.Notification.Name {
    static let DidChangeUserInterfaceStyle = Foundation.Notification.Name("DidChangeUserInterfaceStyle")
}

@objc enum UserInterfaceStyle: Int {
    case light
    case dark

    var image: UIImage {
        switch self {
        case .light:
            return UIImage(named: "emptyMoon")!
        case .dark:
            return UIImage(named: "filledMoon")!
        }
    }
}
