//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

enum Sections: String {
    case dna
    case components
    case fullscreen

    static var all: [Sections] {
        return [
            .dna,
            .components,
            .fullscreen,
        ]
    }

    var numberOfItems: Int {
        switch self {
        case .dna:
            return DnaViews.all.count
        case .components:
            return ComponentViews.all.count
        case .fullscreen:
            return FullscreenViews.all.count
        }
    }

    static func formattedName(for section: Int) -> String {
        let section = Sections.all[section]
        let rawClassName = section.rawValue
        return rawClassName.capitalizingFirstLetter
    }

    static func formattedName(for indexPath: IndexPath) -> String {
        let section = Sections.all[indexPath.section]
        var rawClassName: String
        switch section {
        case .dna:
            rawClassName = DnaViews.all[indexPath.row].rawValue
        case .components:
            rawClassName = ComponentViews.all[indexPath.row].rawValue
        case .fullscreen:
            rawClassName = FullscreenViews.all[indexPath.row].rawValue
        }

        return rawClassName.replacingOccurrences(of: "DemoView", with: "").capitalizingFirstLetter
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
        case .fullscreen:
            let selectedView = FullscreenViews.all[indexPath.row]
            return selectedView.viewController
        }
    }

    private static let lastSelectedRowKey = "lastSelectedRowKey"
    private static let lastSelectedSectionKey = "lastSelectedSectionKey"

    static var lastSelectedIndexPath: IndexPath? {
        get {
            guard let row = UserDefaults.standard.object(forKey: lastSelectedRowKey) as? Int else { return nil }
            guard let section = UserDefaults.standard.object(forKey: lastSelectedSectionKey) as? Int else { return nil }
            return IndexPath(row: row, section: section)
        }
        set {
            if let row = newValue?.row {
                UserDefaults.standard.set(row, forKey: lastSelectedRowKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastSelectedRowKey)
            }

            if let section = newValue?.section {
                UserDefaults.standard.set(section, forKey: lastSelectedSectionKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastSelectedSectionKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
}

enum DnaViews: String {
    case colorDemoView
    case fontDemoView
    case spacingDemoView

    var viewController: UIViewController {
        switch self {
        case .colorDemoView:
            return ViewController<ColorDemoView>()
        case .fontDemoView:
            return ViewController<FontDemoView>()
        case .spacingDemoView:
            return ViewController<SpacingDemoView>()
        }
    }

    static var all: [DnaViews] {
        return [
            .colorDemoView,
            .fontDemoView,
            .spacingDemoView,
        ]
    }
}

enum ComponentViews: String {
    case broadcastDemoView
    case broadcastContainerDemoView
    case buttonDemoView
    case labelDemoView
    case ribbonDemoView
    case textFieldDemoView
    case toastDemoView
    case switchViewDemoView

    var viewController: UIViewController {
        switch self {
        case .broadcastDemoView:
            return ViewController<BroadcastDemoView>()
        case .broadcastContainerDemoView:
            return ViewController<BroadcastContainerDemoView>()
        case .buttonDemoView:
            return ViewController<ButtonDemoView>()
        case .labelDemoView:
            return ViewController<LabelDemoView>()
        case .ribbonDemoView:
            return ViewController<RibbonDemoView>()
        case .textFieldDemoView:
            return ViewController<TextFieldDemoView>()
        case .toastDemoView:
            return ViewController<ToastDemoView>()
        case .switchViewDemoView:
            return ViewController<SwitchViewDemoView>()
        }
    }

    static var all: [ComponentViews] {
        return [
            .broadcastDemoView,
            .broadcastContainerDemoView,
            .buttonDemoView,
            .labelDemoView,
            .ribbonDemoView,
            .textFieldDemoView,
            .toastDemoView,
            .switchViewDemoView,
        ]
    }
}

enum FullscreenViews: String {
    case registerViewDemoView
    case consentViewDemoView
    case emptyViewDemoView
    case marketGridViewDemoView
    case marketView
    case marketGridCellDemoView
    case previewGridViewDemoView
    case previewGridCellDemoView
    case loginViewDemoView

    var viewController: UIViewController {
        switch self {
        case .registerViewDemoView:
            return ViewController<RegisterViewDemoView>()
        case .loginViewDemoView:
            return ViewController<LoginViewDemoView>()
        case .marketGridViewDemoView:
            return ViewController<MarketGridViewDemoView>()
        case .marketView:
            return ViewController<MarketView>()
        case .marketGridCellDemoView:
            return ViewController<MarketGridCellDemoView>()
        case .previewGridViewDemoView:
            return ViewController<PreviewGridViewDemoView>()
        case .previewGridCellDemoView:
            return ViewController<PreviewGridCellDemoView>()
        case .emptyViewDemoView:
            return ViewController<EmptyViewDemoView>()
        case .consentViewDemoView:
            return ViewController<ConsentViewDemoView>()
        }
    }

    static var all: [FullscreenViews] {
        return [
            .registerViewDemoView,
            .consentViewDemoView,
            .emptyViewDemoView,
            .marketGridViewDemoView,
            .marketView,
            .marketGridCellDemoView,
            .previewGridViewDemoView,
            .previewGridCellDemoView,
            .loginViewDemoView,
        ]
    }
}
