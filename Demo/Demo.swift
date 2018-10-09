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
            return DemoViewController<ColorDemoView>()
        case .font:
            return DemoViewController<FontDemoView>()
        case .spacing:
            return DemoViewController<SpacingDemoView>()
        case .assets:
            return DemoViewController<AssetsDemoView>()
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
    case loadingIndicator
    case horizontalSlide
    case easterEggButton

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
            .loadingIndicator,
            .horizontalSlide,
            .easterEggButton
        ]
    }

    public var viewController: UIViewController {
        switch self {
        case .broadcast:
            return DemoViewController<BroadcastDemoView>()
        case .button:
            return DemoViewController<ButtonDemoView>()
        case .label:
            return DemoViewController<LabelDemoView>()
        case .ribbon:
            return DemoViewController<RibbonDemoView>()
        case .textField:
            return DemoViewController<TextFieldDemoView>()
        case .toast:
            return DemoViewController<ToastDemoView>()
        case .switchView:
            return DemoViewController<SwitchViewDemoView>()
        case .inlineConsent:
            return DemoViewController<InlineConsentDemoView>()
        case .consentTransparencyInfo:
            return DemoViewController<ConsentTransparencyInfoDemoView>()
        case .checkbox:
            return DemoViewController<CheckboxDemoView>(withDismissButton: true)
        case .radioButton:
            return DemoViewController<RadioButtonDemoView>(withDismissButton: true)
        case .roundedImageView:
            return DemoViewController<RoundedImageViewDemoView>()
        case .loadingIndicator:
            return DemoViewController<LoadingIndicatorViewDemoView>()
        case .horizontalSlide:
            let presentedViewController = HorizontalSlideDemoViewController()
            let secondViewController = UINavigationController(rootViewController: presentedViewController)
            secondViewController.transitioningDelegate = presentedViewController.transitionDelegate
            secondViewController.modalPresentationStyle = .custom
            return secondViewController
        case .easterEggButton:
            return DemoViewController<EasterEggButtonDemoView>()
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
    case settingsView

    public static var all: [RecyclingViews] {
        return [
            .notificationsListView,
            .favoriteFoldersListView,
            .favoritesListView,
            .savedSearchesListView,
            .marketsGridView,
            .adsGridView,
            .settingsView,
        ]
    }

    public var viewController: UIViewController {
        switch self {
        case .notificationsListView:
            return DemoViewController<NotificationsListViewDemoView>()
        case .favoriteFoldersListView:
            return DemoViewController<FavoriteFoldersListViewDemoView>()
        case .favoritesListView:
            return DemoViewController<FavoritesListViewDemoView>()
        case .savedSearchesListView:
            return DemoViewController<SavedSearchesListViewDemoView>()
        case .marketsGridView:
            return DemoViewController<MarketsGridViewDemoView>()
        case .adsGridView:
            return DemoViewController<AdsGridViewDemoView>()
        case .settingsView:
            return DemoViewController<SettingsViewDemoView>()
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
    case consentToggleView
    case consentActionView
    case loadingView
    case drumMachine

    public static var all: [FullscreenViews] {
        return [
            .frontpageView,
            .popupView,
            .emptyView,
            .reportAdView,
            .reviewView,
            .registerView,
            .loginView,
            .consentToggleView,
            .consentActionView,
            .loadingView,
            .drumMachine
        ]
    }

    public var viewController: UIViewController {
        switch self {
        case .frontpageView:
            return DemoViewController<FrontpageViewDemoView>()
        case .emptyView:
            return DemoViewController<EmptyViewDemoView>()
        case .popupView:
            return DemoViewController<PopupViewDemoView>()
        case .reportAdView:
            return DemoViewController<AdReporterDemoView>(withDismissButton: true)
        case .reviewView:
            return DemoViewController<ReviewViewDemoView>()
        case .registerView:
            return DemoViewController<RegisterViewDemoView>()
        case .loginView:
            return DemoViewController<LoginViewDemoView>()
        case .consentToggleView:
            return DemoViewController<ConsentToggleViewDemoView>()
        case .consentActionView:
            return DemoViewController<ConsentActionViewDemoView>()
        case .loadingView:
            return DemoViewController<LoadingViewDemoView>()
        case .drumMachine:
            return DemoViewController<DrumMachineDemoView>()
        }
    }
}
