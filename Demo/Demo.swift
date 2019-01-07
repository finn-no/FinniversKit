//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum DnaViews: String, CaseIterable {
    case color
    case font
    case spacing
    case assets

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

public enum ComponentViews: String, CaseIterable {
    case button
    case easterEggButton
    case cogWheelButton
    case label
    case ribbon
    case textField
    case toast
    case switchView
    case inlineConsent
    case consentTransparencyInfo
    case bannerTransparency
    case checkbox
    case radioButton
    case roundedImageView
    case loadingIndicator
    case refreshControl
    case horizontalSlide
    case newYearsView
    case bottomSheetMechanis

    public var viewController: UIViewController {
        switch self {
        case .button:
            return DemoViewController<ButtonDemoView>()
        case .easterEggButton:
            return DemoViewController<EasterEggButtonDemoView>()
        case .cogWheelButton:
            return DemoViewController<CogWheelButtonDemoView>()
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
        case .bannerTransparency:
            return DemoViewController<BannerTransparencyDemoView>()
        case .checkbox:
            return DemoViewController<CheckboxDemoView>(withDismissButton: true)
        case .radioButton:
            return DemoViewController<RadioButtonDemoView>(withDismissButton: true)
        case .roundedImageView:
            return DemoViewController<RoundedImageViewDemoView>()
        case .loadingIndicator:
            return DemoViewController<LoadingIndicatorViewDemoView>()
        case .refreshControl:
            return DemoViewController<RefreshControlDemoView>()
        case .horizontalSlide:
            let presentedViewController = HorizontalSlideDemoViewController()
            let secondViewController = UINavigationController(rootViewController: presentedViewController)
            secondViewController.transitioningDelegate = presentedViewController.transition
            secondViewController.modalPresentationStyle = .custom
            return secondViewController
        case .newYearsView:
                return DemoViewController<NewYearsDemoView>()
        case .bottomSheetMechanis:
            return BottomSheetMechanicsDemoViewController()
        }
    }
}

public enum RecyclingViews: String, CaseIterable {
    case notificationsListView
    case favoriteFoldersListView
    case favoritesListView
    case savedSearchesListView
    case marketsGridView
    case adsGridView
    case settingsView

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

public enum FullscreenViews: String, CaseIterable {
    case frontPageView
    case popupView
    case emptyView
    case emptyChristmasView
    case reportAdView
    case reviewView
    case registerView
    case loginView
    case consentToggleView
    case consentActionView
    case loadingView
    case drumMachine
    case snowGlobe
    case soldView

    public var viewController: UIViewController {
        switch self {
        case .frontPageView:
            return DemoViewController<FrontpageViewDemoView>()
        case .emptyView:
            return DemoViewController<EmptyViewDemoView>()
        case .emptyChristmasView:
            return DemoViewController<EmptyChristmasViewDemoView>()
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
        case .snowGlobe:
            return DemoViewController<SnowGlobeDemoView>()
        case .soldView:
            return DemoViewController<SoldViewDemoView>()
        }
    }
}

public enum TableViewCellViews: String, CaseIterable {
    case basicCell
    case basicCellVariations
    case checkboxCell
    case checkboxSubtitleCell
    case heartSubtitleCell
    case iconTitleCell

    public var viewController: UIViewController {
        switch self {
        case .basicCell:
            return DemoViewController<BasicCellDemoView>(withDismissButton: true)
        case .basicCellVariations:
            return DemoViewController<BasicCellVariationsDemoView>(withDismissButton: true)
        case .checkboxCell:
            return DemoViewController<CheckboxCellDemoView>(withDismissButton: true)
        case .checkboxSubtitleCell:
            return DemoViewController<CheckboxSubtitleCellDemoView>(withDismissButton: true)
        case .heartSubtitleCell:
            return DemoViewController<HeartSubtitleCellDemoView>(withDismissButton: true)
        case .iconTitleCell:
            return DemoViewController<IconTitleCellDemoView>(withDismissButton: true)
        }
    }
}
