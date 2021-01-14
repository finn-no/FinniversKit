//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum FullscreenDemoViews: String, DemoViews {
    case searchResultMapView
    case searchResultsView
    case frontPageView
    case popupView
    case emptyView
    case reportAdView
    case buyerPickerView
    case registerView
    case loginEntryView
    case loginView
    case loadingView
    case drumMachineView
    case pianoView
    case snowGlobeView
    case newYearsView
    case soldView
    case confirmationView
    case fullscreenGallery
    case contactFormView
    case addressMapView
    case messageFormView
    case favoriteAdsList
    case verificationActionSheet
    case splashView
    case settingDetails
    case favoriteAdActionView
    case favoriteAdCommentInputView
    case favoriteAdSortingView
    case favoriteFolderActionView
    case favoriteSold
    case betaFeatureView
    case motorTransactionView
    case motorTransactionInvalidUserView
    case motorTransactionInviteCounterpartyView
    case resultView
    case confettiView
    case savedSearchSortingView
    case searchDisplayTypeSelectionView
    case messageUserRequiredSheet
    case motorTransactionInsurancePickerView
    case motorTransactionInsuranceConfirmationView

    public var viewController: UIViewController {
        switch self {
        case .searchResultMapView:
            return SearchResultMapViewDemoViewController()
        case .searchResultsView:
            return DemoViewController<SearchResultsDemoView>(dismissType: .dismissButton)
        case .frontPageView:
            return DemoViewController<FrontpageViewDemoView>()
        case .emptyView:
            return DemoViewController<EmptyViewDemoView>()
        case .popupView:
            return DemoViewController<PopupViewDemoView>()
        case .reportAdView:
            return DemoViewController<AdReporterDemoView>(dismissType: .dismissButton)
        case .buyerPickerView:
            return DemoViewController<BuyerPickerDemoView>()
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
        case .newYearsView:
            return DemoViewController<NewYearsDemoView>()
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
        case .addressMapView:
            return DemoViewController<AddressMapDemoView>(
                dismissType: .dismissButton,
                constrainToBottomSafeArea: false
            )
        case .favoriteAdsList:
            return DemoViewController<FavoriteAdsListDemoView>(constrainToBottomSafeArea: false)
        case .verificationActionSheet:
            let bottomSheet = VerificationActionSheet(viewModel: VerificationViewDefaultData())
            bottomSheet.actionDelegate = VerificationActionSheetDemoDelegate.shared
            return bottomSheet
        case .splashView:
            return DemoViewController<SplashDemoView>(constrainToTopSafeArea: false, constrainToBottomSafeArea: false)
        case .settingDetails:
            let viewController = SettingDetailsDemoViewController()
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
        case .favoriteAdActionView:
            return DemoViewController<FavoriteAdActionDemoView>()
        case .favoriteAdCommentInputView:
            return DemoViewController<FavoriteAdCommentInputDemoView>()
        case .favoriteAdSortingView:
            return DemoViewController<FavoriteAdSortingDemoView>()
        case .favoriteFolderActionView:
            return DemoViewController<FavoriteFolderActionDemoView>()
        case .favoriteSold:
            return DemoViewController<FavoriteSoldDemoView>()
        case .betaFeatureView:
            return DemoViewController<BetaFeatureDemoView>()
        case .motorTransactionView:
            return DemoViewController<MotorTransactionDemoView>()
        case .motorTransactionInvalidUserView:
            return DemoViewController<MotorTransactionInvalidUserDemoView>()
        case .motorTransactionInviteCounterpartyView:
            return DemoViewController<MotorTransactionInviteCounterpartyDemoView>()
        case .resultView:
            return DemoViewController<ResultDemoView>()
        case .confettiView:
            return DemoViewController<ConfettiDemoView>()
        case .savedSearchSortingView:
            return DemoViewController<SavedSearchSortingDemoView>()
        case .searchDisplayTypeSelectionView:
            return DemoViewController<SearchDisplayTypeSelectionDemoView>()
        case .messageUserRequiredSheet:
            let sheet = MessageUserRequiredSheet()
            sheet.configure(MessageUserRequiredData.labelText, buttonText: MessageUserRequiredData.buttonText)
            return sheet
        case .motorTransactionInsurancePickerView:
            return DemoViewController<MotorTransactionInsurancePickerDemoView>()
        case .motorTransactionInsuranceConfirmationView:
            return DemoViewController<MotorTransactionInsuranceConfirmationDemoView>()
        }
    }
}
