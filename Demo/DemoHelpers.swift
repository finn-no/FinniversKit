//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
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

    public static let navigationController = ContainmentOptions(rawValue: 1 << 0)
    public static let tabBarController = ContainmentOptions(rawValue: 1 << 1)
    public static let all: ContainmentOptions = [.navigationController, .tabBarController]

    /// Attaches a navigation bar, a tab bar or both depending on what is returned here.
    /// If you return nil the screen will have no containers.
    ///
    /// - Parameter indexPath: The component's index path
    init?(indexPath: IndexPath) {
        let sectionType = Sections.for(indexPath)
        switch sectionType {
        case .dna:
            guard let screens = DnaViews.all[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            default: return nil
            }
        case .fullscreen:
            guard let screens = FullscreenViews.all[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            default: return nil
            }
        case .components:
            guard let screens = ComponentViews.all[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            default: return nil
            }
        case .recycling:
            guard let screens = RecyclingViews.all[safe: indexPath.row] else {
                return nil
            }
            switch screens {
            default: return nil
            }
        }
    }
}

enum Sections: String {
    case dna
    case components
    case recycling
    case fullscreen

    static var all: [Sections] {
        return [
            .dna,
            .components,
            .recycling,
            .fullscreen,
        ]
    }

    var numberOfItems: Int {
        switch self {
        case .dna:
            return DnaViews.all.count
        case .components:
            return ComponentViews.all.count
        case .recycling:
            return RecyclingViews.all.count
        case .fullscreen:
            return FullscreenViews.all.count
        }
    }

    static func formattedName(for section: Int) -> String {
        let section = Sections.all[section]
        let rawClassName = section.rawValue
        return rawClassName
    }

    static func formattedName(for indexPath: IndexPath) -> String {
        let section = Sections.all[indexPath.section]
        var rawClassName: String
        switch section {
        case .dna:
            rawClassName = DnaViews.all[indexPath.row].rawValue
        case .components:
            rawClassName = ComponentViews.all[indexPath.row].rawValue
        case .recycling:
            rawClassName = RecyclingViews.all[indexPath.row].rawValue
        case .fullscreen:
            rawClassName = FullscreenViews.all[indexPath.row].rawValue
        }

        return rawClassName.capitalizingFirstLetter
    }

    static func `for`(_ indexPath: IndexPath) -> Sections {
        return Sections.all[indexPath.section]
    }

    static func viewController(for indexPath: IndexPath) -> UIViewController? {
        guard let section = Sections.all[safe: indexPath.section] else {
            return nil
        }
        var viewController: UIViewController?
        switch section {
        case .dna:
            let selectedView = DnaViews.all[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .components:
            let selectedView = ComponentViews.all[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .recycling:
            let selectedView = RecyclingViews.all[safe: indexPath.row]
            viewController = selectedView?.viewController
        case .fullscreen:
            let selectedView = FullscreenViews.all[safe: indexPath.row]
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

        return viewController
    }

    var tabletDisplayMode: TabletDisplayMode {
        switch self {
        case .dna, .components, .fullscreen:
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
