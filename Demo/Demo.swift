//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

enum TabletDisplayMode {
    case master
    case detail
    case fullscreen
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
            return Recycling.all.count
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
            rawClassName = Recycling.all[indexPath.row].rawValue
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
        let viewController: UIViewController
        switch section {
        case .dna:
            let selectedView = DnaViews.all[indexPath.row]
            viewController = selectedView.viewController
        case .components:
            let selectedView = ComponentViews.all[indexPath.row]
            viewController = selectedView.viewController
        case .recycling:
            let selectedView = Recycling.all[indexPath.row]
            viewController = selectedView.viewController
        case .fullscreen:
            let selectedView = FullscreenViews.all[indexPath.row]
            viewController = selectedView.viewController
        }

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return viewController
        case .pad:
            let sectionType = Sections.for(indexPath)
            switch sectionType.tabletDisplayMode {
            case .master:
                return SplitViewController(masterViewController: viewController)
            case .detail:
                return SplitViewController(detailViewController: viewController)
            case .fullscreen:
                return viewController
            }
        default:
            fatalError("Not supported")
        }
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
        }
    }
}

enum Recycling: String {
    case marketsGridView
    case adsGridView
    case frontpageGridView
    case notificationsListView

    static var all: [Recycling] {
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
    case consentView
    case emptyView
    case loginView

    static var all: [FullscreenViews] {
        return [
            .registerView,
            .consentView,
            .emptyView,
            .loginView,
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
        case .consentView:
            return ViewController<ConsentViewDemoView>()
        }
    }
}
