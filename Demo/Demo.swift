//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import UIKit

public enum DnaViews: String {
    case color
    case font
    case spacing
    case assets

    public static var all: [DnaViews] {
        return [
            .color,
            .font,
            .spacing,
            .assets,
        ]
    }

    public var viewController: UIViewController {
        switch self {
        case .color:
            return ViewController<ColorDemoView>()
        case .font:
            return ViewController<FontDemoView>()
        case .spacing:
            return ViewController<SpacingDemoView>()
        case .assets:
            return ViewController<AssetsDemoView>()
        }
    }
}

public enum ComponentViews: String {
    case broadcast
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

    public static var all: [ComponentViews] {
        return [
            .broadcast,
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

    public var viewController: UIViewController {
        switch self {
        case .broadcast:
            return ViewController<BroadcastDemoView>()
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

public enum RecyclingViews: String {
    case notificationsListView
    case favoriteFoldersListView
    case favoritesListView
    case savedSearchesListView
    case marketsGridView
    case adsGridView

    public static var all: [RecyclingViews] {
        return [
            .notificationsListView,
            .favoriteFoldersListView,
            .favoritesListView,
            .savedSearchesListView,
            .marketsGridView,
            .adsGridView,
        ]
    }

    public var viewController: UIViewController {
        switch self {
        case .notificationsListView:
            return ViewController<NotificationsListViewDemoView>()
        case .favoriteFoldersListView:
            return ViewController<FavoriteFoldersListViewDemoView>()
        case .favoritesListView:
            return ViewController<FavoritesListViewDemoView>()
        case .savedSearchesListView:
            return ViewController<SavedSearchesListViewDemoView>()
        case .marketsGridView:
            return ViewController<MarketsGridViewDemoView>()
        case .adsGridView:
            return ViewController<AdsGridViewDemoView>()
        }
    }
}

public enum FullscreenViews: String {
    case frontpageView
    case popupView
    case emptyView
    case reportAdView
    case reviewView
    case registerView
    case loginView
    case errorView

    public static var all: [FullscreenViews] {
        return [
            .frontpageView,
            .popupView,
            .emptyView,
            .reportAdView,
            .reviewView,
            .registerView,
            .loginView,
            .errorView
        ]
    }

    public var viewController: UIViewController {
        switch self {
        case .frontpageView:
            return ViewController<FrontpageViewDemoView>()
        case .emptyView:
            return ViewController<EmptyViewDemoView>()
        case .popupView:
            return ViewController<PopupViewDemoView>()
        case .reportAdView:
            return ViewController<AdReporterDemoView>(usingDoubleTap: false)
        case .reviewView:
            return ViewController<ReviewViewDemoView>()
        case .registerView:
            return ViewController<RegisterViewDemoView>()
        case .loginView:
            return ViewController<LoginViewDemoView>()
        case .errorView:
            return ViewController<ErrorViewDemoView>()
        }
    }
}
