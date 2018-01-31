//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

// MARK: - TroikaViews

enum TroikaViews: String {

    case RegisterViewPlayground
    case ButtonPlayground
    case LabelPlayground
    case LoginViewPlayground
    case MarketGridViewPlayground
    case MarketView
    case MarketGridCellPlayground
    case PreviewGridViewPlayground
    case PreviewGridCellPlayground
    case RibbonPlayground
    case TextFieldPlayground
    case ToastPlayground
    case EmptyViewPlayground

    func viewController() -> UIViewController {
        switch self {
        case .RegisterViewPlayground:
            return ViewController<RegisterViewPlayground>()
        case .ButtonPlayground:
            return ViewController<ButtonPlayground>()
        case .LabelPlayground:
            return ViewController<LabelPlayground>()
        case .LoginViewPlayground:
            return ViewController<LoginViewPlayground>()
        case .MarketGridViewPlayground:
            return ViewController<MarketGridViewPlayground>()
        case .MarketView:
            return ViewController<MarketView>()
        case .MarketGridCellPlayground:
            return ViewController<MarketGridCellPlayground>()
        case .PreviewGridViewPlayground:
            return ViewController<PreviewGridViewPlayground>()
        case .PreviewGridCellPlayground:
            return ViewController<PreviewGridCellPlayground>()
        case .RibbonPlayground:
            return ViewController<RibbonPlayground>()
        case .TextFieldPlayground:
            return ViewController<TextFieldPlayground>()
        case .ToastPlayground:
            return ViewController<ToastPlayground>()
        case .EmptyViewPlayground:
            return ViewController<EmptyViewPlayground>()
        }
    }

    static var all: [TroikaViews] {
        return [
            .RegisterViewPlayground,
            .ButtonPlayground,
            .LabelPlayground,
            .LoginViewPlayground,
            .MarketGridViewPlayground,
            .MarketView,
            .MarketGridCellPlayground,
            .PreviewGridViewPlayground,
            .PreviewGridCellPlayground,
            .RibbonPlayground,
            .TextFieldPlayground,
            .ToastPlayground,
            .EmptyViewPlayground,
        ]
    }
}
