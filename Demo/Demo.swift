//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

// MARK: - TroikaViews

enum TroikaViews: String {

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

    static var all: [TroikaViews] {
        return [
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
