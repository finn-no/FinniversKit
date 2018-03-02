//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

enum FinniversKitViews: String {
    case colorDemoView
    case fontDemoView
    case spacingDemoView
    case registerViewDemoView
    case broadcastDemoView
    case broadcastContainerDemoView
    case buttonDemoView
    case labelDemoView
    case loginViewDemoView
    case marketGridViewDemoView
    case marketView
    case marketGridCellDemoView
    case previewGridViewDemoView
    case previewGridCellDemoView
    case ribbonDemoView
    case textFieldDemoView
    case toastDemoView
    case emptyViewDemoView
    case consentViewDemoView
    case toggleSwitchViewDemoView

    func viewController() -> UIViewController {
        switch self {
        case .colorDemoView:
            return ViewController<ColorDemoView>()
        case .fontDemoView:
            return ViewController<FontDemoView>()
        case .spacingDemoView:
            return ViewController<SpacingDemoView>()
        case .registerViewDemoView:
            return ViewController<RegisterViewDemoView>()
        case .broadcastDemoView:
            return ViewController<BroadcastDemoView>()
        case .broadcastContainerDemoView:
            return ViewController<BroadcastContainerDemoView>()
        case .buttonDemoView:
            return ViewController<ButtonDemoView>()
        case .labelDemoView:
            return ViewController<LabelDemoView>()
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
        case .ribbonDemoView:
            return ViewController<RibbonDemoView>()
        case .textFieldDemoView:
            return ViewController<TextFieldDemoView>()
        case .toastDemoView:
            return ViewController<ToastDemoView>()
        case .emptyViewDemoView:
            return ViewController<EmptyViewDemoView>()
        case .consentViewDemoView:
            return ViewController<ConsentViewDemoView>()
        case .toggleSwitchViewDemoView:
            return ViewController<ToggleSwitchViewDemoView>()
        }
    }

    static var all: [FinniversKitViews] {
        return [
            .colorDemoView,
            .fontDemoView,
            .spacingDemoView,
            .registerViewDemoView,
            .broadcastDemoView,
            .broadcastContainerDemoView,
            .buttonDemoView,
            .labelDemoView,
            .loginViewDemoView,
            .marketGridViewDemoView,
            .marketView,
            .marketGridCellDemoView,
            .previewGridViewDemoView,
            .previewGridCellDemoView,
            .ribbonDemoView,
            .textFieldDemoView,
            .toastDemoView,
            .emptyViewDemoView,
            .consentViewDemoView,
            .toggleSwitchViewDemoView,
        ]
    }

    private static let lastSelectedViewRawValueKey = "lastSelectedViewRawValue"

    static var lastSelectedView: FinniversKitViews? {
        get {
            guard let lastSelectedViewRawValue = UserDefaults.standard.value(forKey: lastSelectedViewRawValueKey) as? String else {
                return nil
            }

            return FinniversKitViews(rawValue: lastSelectedViewRawValue)
        }
        set {
            UserDefaults.standard.set(newValue?.rawValue, forKey: lastSelectedViewRawValueKey)
            UserDefaults.standard.synchronize()
        }
    }
}
