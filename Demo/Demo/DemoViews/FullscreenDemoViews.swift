//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum FullscreenDemoViews: String, CaseIterable {
    case searchResultMapView
    case frontPageView
    case popupView
    case emptyView
    case reportAdView
    case reviewView
    case registerView
    case loginEntryView
    case loginView
    case consentToggleView
    case consentActionView
    case loadingView
    case drumMachineView
    case pianoView
    case snowGlobeView
    case soldView
    case confirmationView
    case fullscreenGallery
    case contactFormView
    case addressView
    case messageFormView
    case receiptView
    case favoriteAdsList
    case favoriteFolderActionSheet
    case favoriteAdSortingSheet
    case favoriteAdActionSheet
    case favoriteAdCommentSheet
    case verificationActionSheet
    case splashView
    case popovers

    public static var items: [FullscreenDemoViews] {
        return allCases.sorted { $0.rawValue < $1.rawValue }
    }

    public var viewController: UIViewController {
        switch self {
        case .searchResultMapView:
            return SearchResultMapViewDemoViewController()
        case .frontPageView:
            return DemoViewControllerContainer<FrontpageViewDemoView>()
        case .emptyView:
            return DemoViewControllerContainer<EmptyViewDemoView>()
        case .popupView:
            return DemoViewControllerContainer<PopupViewDemoView>()
        case .reportAdView:
            return DemoViewControllerContainer<AdReporterDemoView>(dismissType: .dismissButton)
        case .reviewView:
            return DemoViewControllerContainer<ReviewViewDemoView>()
        case .registerView:
            return DemoViewControllerContainer<RegisterViewDemoView>()
        case .loginEntryView:
            return LoginEntryViewDemoViewController(constrainToBottomSafeArea: false)
        case .loginView:
            return DemoViewControllerContainer<LoginViewDemoView>()
        case .consentToggleView:
            return DemoViewControllerContainer<ConsentToggleViewDemoView>(containmentOptions: [.navigationController, .tabBarController])
        case .consentActionView:
            return DemoViewControllerContainer<ConsentActionViewDemoView>(containmentOptions: [.navigationController, .tabBarController])
        case .loadingView:
            return DemoViewControllerContainer<LoadingViewDemoView>()
        case .drumMachineView:
            return DemoViewControllerContainer<DrumMachineDemoView>()
        case .pianoView:
            return DemoViewControllerContainer<PianoDemoView>(supportedInterfaceOrientations: .landscape)
        case .snowGlobeView:
            return DemoViewControllerContainer<SnowGlobeDemoView>()
        case .soldView:
            return DemoViewControllerContainer<SoldViewDemoView>()
        case .confirmationView:
            return DemoViewControllerContainer<ConfirmationViewDemoView>()
        case .fullscreenGallery:
            return FullscreenGalleryDemoViewController()
        case .contactFormView:
            return DemoViewControllerContainer<ContactFormDemoView>()
        case .messageFormView:
            let bottomSheet = MessageFormBottomSheet(viewModel: MessageFormDemoViewModel())
            bottomSheet.messageFormDelegate = MessageFormDemoPresenter.shared
            return bottomSheet
        case .receiptView:
            return DemoViewControllerContainer<ReceiptViewDemoView>()
        case .addressView:
            return DemoViewControllerContainer<AddressViewDemoView>(containmentOptions: [.navigationController, .tabBarController])
        case .favoriteAdsList:
            return FavoriteAdsListDemoViewController(dismissType: .dismissButton, containmentOptions: .navigationController)
        case .favoriteFolderActionSheet:
            let bottomSheet = FavoriteFolderActionSheet(viewModel: .default, isShared: true)
            bottomSheet.actionDelegate = FavoriteFolderActionSheetDemoDelegate.shared
            return bottomSheet
        case .favoriteAdSortingSheet:
            let bottomSheet = FavoriteAdSortingSheet(viewModel: .default, selectedSortOption: .lastAdded)
            bottomSheet.sortingDelegate = FavoriteAdSortingSheetDemoDelegate.shared
            return bottomSheet
        case .favoriteAdActionSheet:
            let bottomSheet = FavoriteAdActionSheet(viewModel: .default)
            bottomSheet.actionDelegate = FavoriteAdActionSheetDemoDelegate.shared
            return bottomSheet
        case .favoriteAdCommentSheet:
            let bottomSheet = FavoriteAdCommentSheet(
                commentViewModel: .default,
                adViewModel: FavoriteAdsFactory.create().last!,
                remoteImageViewDataSource: FavoriteAdCommentSheetDemoDelegate.shared
            )
            bottomSheet.commentDelegate = FavoriteAdCommentSheetDemoDelegate.shared
            return bottomSheet
        case .verificationActionSheet:
            let bottomSheet = VerificationActionSheet(viewModel: VerificationViewDefaultData())
            bottomSheet.actionDelegate = VerificationActionSheetDemoDelegate.shared
            return bottomSheet
        case .splashView:
            return DemoViewControllerContainer<SplashDemoView>(constrainToTopSafeArea: false, constrainToBottomSafeArea: false)
        case .popovers:
            return PopoversDemoViewController()
        }
    }
}
