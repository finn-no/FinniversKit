//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

// MARK: - TroikaViews

enum TroikaViews: String {

    case RegisterViewDemo
    case ButtonDemo
    case LabelDemo
    case LoginViewDemo
    case MarketGridViewDemo
    case MarketView
    case MarketGridCellDemo
    case PreviewGridViewDemo
    case PreviewGridCellDemo
    case RibbonDemo
    case TextFieldDemo
    case ToastDemo
    case EmptyViewDemo

    func viewController() -> UIViewController {
        switch self {
        case .RegisterViewDemo:
            return ViewController<RegisterViewDemo>()
        case .ButtonDemo:
            return ViewController<ButtonDemo>()
        case .LabelDemo:
            return ViewController<LabelDemo>()
        case .LoginViewDemo:
            return ViewController<LoginViewDemo>()
        case .MarketGridViewDemo:
            return ViewController<MarketGridViewDemo>()
        case .MarketView:
            return ViewController<MarketView>()
        case .MarketGridCellDemo:
            return ViewController<MarketGridCellDemo>()
        case .PreviewGridViewDemo:
            return ViewController<PreviewGridViewDemo>()
        case .PreviewGridCellDemo:
            return ViewController<PreviewGridCellDemo>()
        case .RibbonDemo:
            return ViewController<RibbonDemo>()
        case .TextFieldDemo:
            return ViewController<TextFieldDemo>()
        case .ToastDemo:
            return ViewController<ToastDemo>()
        case .EmptyViewDemo:
            return ViewController<EmptyViewDemo>()
        }
    }

    static var all: [TroikaViews] {
        return [
            .RegisterViewDemo,
            .ButtonDemo,
            .LabelDemo,
            .LoginViewDemo,
            .MarketGridViewDemo,
            .MarketView,
            .MarketGridCellDemo,
            .PreviewGridViewDemo,
            .PreviewGridCellDemo,
            .RibbonDemo,
            .TextFieldDemo,
            .ToastDemo,
            .EmptyViewDemo,
        ]
    }
}
