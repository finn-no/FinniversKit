//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - FinniversViews

enum FinniversViews: String {
    case colorDemoView
    case fontDemoView
    case spacingDemoView
    case registerViewDemoView
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
        }
    }

    static var all: [FinniversViews] {
        return [
            .colorDemoView,
            .fontDemoView,
            .spacingDemoView,
            .registerViewDemoView,
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
        ]
    }
}
