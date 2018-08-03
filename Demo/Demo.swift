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
            _ = DnaViews.all[indexPath.row]
            return nil
        case .fullscreen:
            let screens = FullscreenViews.all[indexPath.row]
            switch screens {
            case .reportAdView:
//                self = .navigationController
                return nil
            default:
                return nil
            }
        case .components:
            let selected = ComponentViews.all[indexPath.row]
            switch selected {
            case .toast:
                self = .all
            default:
                return nil
            }
        case .recycling:
            _ = RecyclingViews.all[indexPath.row]
            return nil
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

    static func viewController(for indexPath: IndexPath) -> UIViewController {
        let section = Sections.all[indexPath.section]
        var viewController: UIViewController
        switch section {
        case .dna:
            let selectedView = DnaViews.all[indexPath.row]
            viewController = selectedView.viewController
        case .components:
            let selectedView = ComponentViews.all[indexPath.row]
            viewController = selectedView.viewController
        case .recycling:
            let selectedView = RecyclingViews.all[indexPath.row]
            viewController = selectedView.viewController
        case .fullscreen:
            let selectedView = FullscreenViews.all[indexPath.row]
            viewController = selectedView.viewController
        }

        let sectionType = Sections.for(indexPath)
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            switch sectionType.tabletDisplayMode {
            case .master:
                viewController = SplitViewController(masterViewController: viewController)
            case .detail:
                viewController = SplitViewController(detailViewController: viewController)
            default:
                break
            }
        default:
            break
        }

        let shouldIncludeNavigationController = ContainmentOptions(indexPath: indexPath)?.contains(.navigationController) ?? false
        if shouldIncludeNavigationController {
            viewController = UINavigationController(rootViewController: viewController)
        }

        let shouldIncludeTabBarController = ContainmentOptions(indexPath: indexPath)?.contains(.tabBarController) ?? false
        if shouldIncludeTabBarController {
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [viewController]
            viewController = tabBarController
        }

        return viewController
    }

    var tabletDisplayMode: TabletDisplayMode {
        switch self {
        case .dna, .components, .fullscreen:
            return .fullscreen
        case .recycling:
            return .master
        }
    }
}

enum DnaViews: String {
    case color
    case font
    case spacing

    static var all: [DnaViews] {
        return [
            .color,
            .font,
            .spacing,
        ]
    }

    var viewController: UIViewController {
        switch self {
        case .color:
            return ViewController<ColorDemoView>()
        case .font:
            return ViewController<FontDemoView>()
        case .spacing:
            return ViewController<SpacingDemoView>()
        }
    }
}

enum ComponentViews: String {
    case broadcast
    case broadcastContainer
    case button
    case label
    case ribbon
    case textField
    case toast
    case switchView
    case inlineConsent
    case consentTransparencyInfo
    case checkbox
    case radioButton
    case roundedImageView

    static var all: [ComponentViews] {
        return [
            .broadcast,
            .broadcastContainer,
            .button,
            .label,
            .ribbon,
            .textField,
            .toast,
            .switchView,
            .inlineConsent,
            .consentTransparencyInfo,
            .checkbox,
            .radioButton,
            .roundedImageView,
        ]
    }

    var viewController: UIViewController {
        switch self {
        case .broadcast:
            return ViewController<BroadcastDemoView>()
        case .broadcastContainer:
            return ViewController<BroadcastContainerDemoView>()
        case .button:
            return ViewController<ButtonDemoView>()
        case .label:
            return ViewController<LabelDemoView>()
        case .ribbon:
            return ViewController<RibbonDemoView>()
        case .textField:
            return ViewController<TextFieldDemoView>()
        case .toast:
            return ViewController<ToastDemoView>()
        case .switchView:
            return ViewController<SwitchViewDemoView>()
        case .inlineConsent:
            return ViewController<InlineConsentDemoView>()
        case .consentTransparencyInfo:
            return ViewController<ConsentTransparencyInfoDemoView>()
        case .checkbox:
            return ViewController<CheckboxDemoView>(usingDoubleTap: false)
        case .radioButton:
            return ViewController<RadioButtonDemoView>(usingDoubleTap: false)
        case .roundedImageView:
            return ViewController<RoundedImageViewDemoView>()
        }
    }
}

enum RecyclingViews: String {
    case marketsGridView
    case adsGridView
    case frontpageGridView
    case notificationsListView

    static var all: [RecyclingViews] {
        return [
            .marketsGridView,
            .adsGridView,
            .frontpageGridView,
            .notificationsListView,
        ]
    }

    var viewController: UIViewController {
        switch self {
        case .marketsGridView:
            return ViewController<MarketsGridViewDemoView>()
        case .adsGridView:
            return ViewController<AdsGridViewDemoView>()
        case .frontpageGridView:
            return ViewController<FrontpageGridViewDemoView>()
        case .notificationsListView:
            return ViewController<NotificationsListViewDemoView>()
        }
    }
}

enum FullscreenViews: String {
    case registerView
    case popupView
    case emptyView
    case loginView
    case reportAdView
    case reviewView

    static var all: [FullscreenViews] {
        return [
            .registerView,
            .popupView,
            .emptyView,
            .loginView,
            .reportAdView,
            .reviewView,
        ]
    }

    var viewController: UIViewController {
        switch self {
        case .registerView:
            return ViewController<RegisterViewDemoView>()
        case .loginView:
            return ViewController<LoginViewDemoView>()
        case .emptyView:
            return ViewController<EmptyViewDemoView>()
        case .popupView:
            return ViewController<PopupViewDemoView>()
        case .reportAdView:
            return ViewController<AdReporterDemoView>(usingDoubleTap: false)
        case .reviewView:
            return ViewController<ReviewViewDemoView>()
        }
    }
}
