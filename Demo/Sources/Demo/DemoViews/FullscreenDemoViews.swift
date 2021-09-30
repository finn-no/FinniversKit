//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum FullscreenDemoViews: String, DemoViews {
    case searchResultMapView
    case frontPageView
    case promotionFrontPageView
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
    case soldView
    case confirmationView
    case fullscreenGallery
    case contactFormView
    case addressMapView
    case messageFormView
    case favoriteAdsList
    case verificationActionSheet
    case settingDetails
    case favoriteAdActionView
    case favoriteAdCommentInputView
    case favoriteFolderActionView
    case favoriteSold
    case betaFeatureView
    case resultView
    case confettiView
    case messageUserRequiredSheet
    case frontPageViewNew

    public var viewController: UIViewController {
        switch self {
        case .searchResultMapView:
            return SearchResultMapViewDemoViewController()
        case .frontPageView:
            return DemoViewController<FrontpageViewDemoView>()
        case .frontPageViewNew:
            return DemoViewController<NewFrontPageDemoView>()
        case .promotionFrontPageView:
            return DemoViewController<PromotionFrontpageViewDemoView>()
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
        case .favoriteFolderActionView:
            return DemoViewController<FavoriteFolderActionDemoView>()
        case .favoriteSold:
            return DemoViewController<FavoriteSoldDemoView>()
        case .betaFeatureView:
            return DemoViewController<BetaFeatureDemoView>()
        case .resultView:
            return DemoViewController<ResultDemoView>()
        case .confettiView:
            return DemoViewController<ConfettiDemoView>()
        case .messageUserRequiredSheet:
            let sheet = MessageUserRequiredSheet()
            sheet.configure(MessageUserRequiredData.labelText, buttonText: MessageUserRequiredData.buttonText)
            return sheet
        }
    }
}
