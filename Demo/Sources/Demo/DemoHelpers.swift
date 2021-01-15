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

enum Sections: String, CaseIterable {
    case dna
    case components
    case cells
    case recycling
    case fullscreen
    @available(iOS 13.0, *) case swiftui

    static var allCases: [Sections] {
        var cases: [Sections] = [.dna, .components, .cells, .recycling, .fullscreen]

        if #available(iOS 13.0, *) {
            cases.append(.swiftui)
        }

        return cases
    }

    static var items: [Sections] {
        return allCases
    }

    var numberOfItems: Int {
        switch self {
        case .dna:
            return DnaDemoViews.items.count
        case .components:
            return ComponentDemoViews.items.count
        case .cells:
            return CellsDemoViews.items.count
        case .recycling:
            return RecyclingDemoViews.items.count
        case .fullscreen:
            return FullscreenDemoViews.items.count
        case .swiftui:
            if #available(iOS 13.0, *) {
                return SwiftUIDemoViews.items.count
            }
            return 0
        }
    }

    static func title(for section: Int) -> String {
        let section = Sections.items[section]
        let rawClassName = section.rawValue
        return rawClassName
    }

    static func formattedNames(for section: Int) -> [String] {
        let section = Sections.items[section]
        let names: [String]
        switch section {
        case .dna:
            names = DnaDemoViews.items.map { $0.rawValue.capitalizingFirstLetter }
        case .components:
            names = ComponentDemoViews.items.map { $0.rawValue.capitalizingFirstLetter }
        case .cells:
            names = CellsDemoViews.items.map { $0.rawValue.capitalizingFirstLetter }
        case .recycling:
            names = RecyclingDemoViews.items.map { $0.rawValue.capitalizingFirstLetter }
        case .fullscreen:
            names = FullscreenDemoViews.items.map { $0.rawValue.capitalizingFirstLetter }
        case .swiftui:
            if #available(iOS 13.0, *) {
                names = SwiftUIDemoViews.items.map { $0.rawValue.capitalizingFirstLetter }
            } else {
                names = []
            }
        }
        return names
    }


    static func formattedName(for indexPath: IndexPath) -> String {
        let section = Sections.items[indexPath.section]
        var rawClassName: String
        switch section {
        case .dna:
            rawClassName = DnaDemoViews.items[indexPath.row].rawValue
        case .components:
            rawClassName = ComponentDemoViews.items[indexPath.row].rawValue
        case .cells:
            rawClassName = CellsDemoViews.items[indexPath.row].rawValue
        case .recycling:
            rawClassName = RecyclingDemoViews.items[indexPath.row].rawValue
        case .fullscreen:
            rawClassName = FullscreenDemoViews.items[indexPath.row].rawValue
        case .swiftui:
            if #available(iOS 13.0, *) {
                rawClassName = SwiftUIDemoViews.items[indexPath.row].rawValue
            } else {
                rawClassName = ""
            }
        }

        return rawClassName.capitalizingFirstLetter
    }

    static func `for`(_ indexPath: IndexPath) -> Sections {
        return Sections.items[indexPath.section]
    }

    // swiftlint:disable:next cyclomatic_complexity
    static func viewController(for indexPath: IndexPath) -> UIViewController? {
        guard let section = Sections.items[safe: indexPath.section] else {
            return nil
        }
        var viewController: UIViewController?
        switch section {
        case .dna:
            let selectedView = DnaDemoViews.items[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .components:
            let selectedView = ComponentDemoViews.items[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .cells:
            let selectedView = CellsDemoViews.items[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .recycling:
            let selectedView = RecyclingDemoViews.items[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .fullscreen:
            let selectedView = FullscreenDemoViews.items[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .swiftui:
            if #available(iOS 13.0, *) {
                let selectedView = SwiftUIDemoViews.items[safe: indexPath.row]
                viewController = selectedView?.viewController
            }
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

        let containmentOptions = (viewController as? Containable)?.containmentOptions ?? .none
        let shouldIncludeNavigationController = containmentOptions.contains(.navigationController)
        if shouldIncludeNavigationController {
            if let unwrappedViewController = viewController {
                viewController = NavigationController(rootViewController: unwrappedViewController)
            }
        }

        let shouldIncludeTabBarController = containmentOptions.contains(.tabBarController)
        if shouldIncludeTabBarController {
            let tabBarController = UITabBarController()
            if let unwrappedViewController = viewController {
                tabBarController.viewControllers = [unwrappedViewController]
                viewController = tabBarController
            }
        }

        let shouldPresentInBottomSheet = containmentOptions.contains(.bottomSheet)
        if shouldPresentInBottomSheet {
            if let unwrappedViewController = viewController {
                let bottomSheet = BottomSheet(rootViewController: unwrappedViewController)
                viewController = bottomSheet
            }
        }

        return viewController
    }

    var tabletDisplayMode: TabletDisplayMode {
        return .fullscreen
    }
}

extension Array {
    /// Returns nil if index < count
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : .none
    }

}

extension Foundation.Notification.Name {
    static let didChangeUserInterfaceStyle = Foundation.Notification.Name("didChangeUserInterfaceStyle")
}

@objc enum UserInterfaceStyle: Int {
    case light = 1
    case dark = 2

    var image: UIImage {
        switch self {
        case .light:
            return UIImage(named: .emptyMoon)
        case .dark:
            return UIImage(named: .filledMoon)
        }
    }
}
