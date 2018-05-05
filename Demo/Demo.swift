//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

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

    static func section(for indexPath: IndexPath) -> Sections {
        return Sections.all[indexPath.section]
    }

    static func viewController(for indexPath: IndexPath) -> UIViewController {
        let section = Sections.all[indexPath.section]
        switch section {
        case .dna:
            let selectedView = DnaViews.all[indexPath.row]
            return selectedView.viewController
        case .components:
            let selectedView = ComponentViews.all[indexPath.row]
            return selectedView.viewController
        case .recycling:
            let selectedView = Recycling.all[indexPath.row]
            return selectedView.viewController
        case .fullscreen:
            let selectedView = FullscreenViews.all[indexPath.row]
            return selectedView.viewController
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
    case notificationsListView
    case marketsGridView
    case adsGridView

    static var all: [Recycling] {
        return [
            .notificationsListView,
            .marketsGridView,
            .adsGridView,
        ]
    }

    var viewController: UIViewController {
        switch self {
        case .notificationsListView:
            return ViewController<NotificationsListViewDemoView>()
        case .marketsGridView:
            return ViewController<MarketsGridViewDemoView>()
        case .adsGridView:
            return ViewController<AdsGridViewDemoView>()
        }
    }
}

enum FullscreenViews: String {
    case frontpageView
    case registerView
    case consentView
    case emptyView
    case loginView

    static var all: [FullscreenViews] {
        return [
            .frontpageView,
            .registerView,
            .consentView,
            .emptyView,
            .loginView,
        ]
    }

    var viewController: UIViewController {
        switch self {
        case .frontpageView:
            return ViewController<FrontpageViewDemoView>()
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
