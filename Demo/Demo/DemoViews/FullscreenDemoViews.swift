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
    case settingsDetails

    public static var items: [FullscreenDemoViews] {
        return allCases.sorted { $0.rawValue < $1.rawValue }
    }

    public var viewController: UIViewController {
        switch self {
        case .searchResultMapView:
            return SearchResultMapViewDemoViewController()
        case .frontPageView:
            return DemoViewController<FrontpageViewDemoView>()
        case .emptyView:
            return DemoViewController<EmptyViewDemoView>()
        case .popupView:
            return DemoViewController<PopupViewDemoView>()
        case .reportAdView:
            return DemoViewController<AdReporterDemoView>(dismissType: .dismissButton)
        case .reviewView:
            return DemoViewController<ReviewViewDemoView>()
        case .registerView:
            return DemoViewController<RegisterViewDemoView>()
        case .loginEntryView:
            return LoginEntryViewDemoViewController(constrainToBottomSafeArea: false)
        case .loginView:
            return DemoViewController<LoginViewDemoView>()
        case .loadingView:
            return DemoViewController<LoadingViewDemoView>()
        case .drumMachineView:
            return DemoViewController<DrumMachineDemoView>()
        case .pianoView:
            return DemoViewController<PianoDemoView>(supportedInterfaceOrientations: .landscape)
        case .snowGlobeView:
            return DemoViewController<SnowGlobeDemoView>()
        case .soldView:
            return DemoViewController<SoldViewDemoView>()
        case .confirmationView:
            return DemoViewController<ConfirmationViewDemoView>()
        case .fullscreenGallery:
            return FullscreenGalleryDemoViewController()
        case .contactFormView:
            return DemoViewController<ContactFormDemoView>()
        case .messageFormView:
            let bottomSheet = MessageFormBottomSheet(viewModel: MessageFormDemoViewModel())
            bottomSheet.messageFormDelegate = MessageFormDemoPresenter.shared
            return bottomSheet
        case .receiptView:
            return DemoViewController<ReceiptViewDemoView>()
        case .addressView:
            return DemoViewController<AddressViewDemoView>(containmentOptions: [.navigationController, .tabBarController])
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
            return DemoViewController<SplashDemoView>(constrainToTopSafeArea: false, constrainToBottomSafeArea: false)
        case .popovers:
            return PopoversDemoViewController()
        case .settingsDetails:
            let viewController = SettingsDetailsDemoViewController()
            viewController.view.layoutIfNeeded()
            let contentHeight = viewController.contentSize.height

            let bottomSheet = BottomSheet(
                rootViewController: viewController,
                height: .init(
                    compact: contentHeight,
                    expanded: contentHeight
                )
            )

            viewController.bottomSheet = bottomSheet
            return bottomSheet
        }
    }
}
