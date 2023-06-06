//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum ComponentDemoViews: String, DemoViews {
    case addressCardView
    case button
    case multilineButton
    case floatingButton
    case cogWheelButton
    case iconButton
    case label
    case ribbon
    case textField
    case textView
    case toast
    case switchView
    case infobox
    case consentTransparencyInfo
    case bannerTransparencyView
    case checkbox
    case radioButton
    case roundedImageView
    case loadingIndicator
    case refreshControl
    case reviewButtonView
    case horizontalSlide
    case bottomSheetMechanics
    case feedbackView
    case happinessRating
    case earthHourView
    case broadcast
    case klimabroletView
    case christmasWishListView
    case nativeAdvert
    case callout
    case detailCallout
    case phaseList
    case iconCollection
    case disclaimerView
    case questionnaireView
    case tweakable
    case stepSlider
    case loanCalculatorView
    case verificationView
    case panel
    case visibilityDrivenTitleView
    case selectorTitleView
    case priming
    case footerButtonView
    case checkmarkTitleView
    case viewingsListView
    case viewingsRedesignView
    case selfDeclarationView
    case collapsibleContentView
    case columnListsView
    case keyValueGridView
//    case objectPagePriceView
    case linkButtonListView
    case safetyElementsView
    case contractActionView
//    case objectPageTitleView
    case favoriteButton
    case sendInviteView
    case navigationLinkView
    case numberedListView
    case transactionEntryView
    case blockUserView
    case loadingRetryView
    case promotionView
    case frontPageSavedSearchesView
    case overFlowCollectionView
    case scrollableTabDemoView
    case monthAndYearPickerView
    case searchView
    case addressComponentView
    case selectionListCheckboxView
    case selectionListRadiobuttonView
    case selectionListSeparatedRadiobuttonView
    case badgeView
    case jobApplyBox
    case jobKeyInfo
    case myAdsListView
    case brazePromotionView
    case mapAddressButton
    case hyperlinkTextView

    var title: String? {
        switch self {
        case .selectionListCheckboxView:
            return "SelectionListView - checkboxes"
        case .selectionListRadiobuttonView:
            return "SelectionListView - radio buttons"
        case .selectionListSeparatedRadiobuttonView:
            return "SelectionListView - separated radio buttons"
        default:
            return nil
        }
    }

    public var viewController: UIViewController {
        switch self {
        case .addressCardView:
            return DemoViewController<AddressCardDemoView>()
        case .button:
            return DemoViewController<ButtonDemoView>()
        case .multilineButton:
            return DemoViewController<MultilineButtonDemoView>()
        case .floatingButton:
            return DemoViewController<FloatingButtonDemoView>()
        case .reviewButtonView:
            return DemoViewController<ReviewButtonViewDemoView>()
        case .cogWheelButton:
            return DemoViewController<CogWheelButtonDemoView>()
        case .iconButton:
            return DemoViewController<IconButtonDemoView>()
        case .label:
            return DemoViewController<LabelDemoView>()
        case .ribbon:
            return DemoViewController<RibbonDemoView>()
        case .textField:
            return DemoViewController<TextFieldDemoView>()
        case .textView:
            return DemoViewController<TextViewDemoView>()
        case .toast:
            return DemoViewController<ToastDemoView>()
        case .switchView:
            return DemoViewController<SwitchViewDemoView>()
        case .infobox:
            return DemoViewController<InfoboxDemoView>()
        case .consentTransparencyInfo:
            return DemoViewController<ConsentTransparencyInfoDemoView>()
        case .bannerTransparencyView:
            return DemoViewController<BannerTransparencyDemoView>(containmentOptions: .bottomSheet)
        case .checkbox:
            return DemoViewController<CheckboxDemoView>(dismissType: .dismissButton)
        case .radioButton:
            return DemoViewController<RadioButtonDemoView>(dismissType: .dismissButton)
        case .roundedImageView:
            return DemoViewController<RoundedImageViewDemoView>()
        case .loadingIndicator:
            return DemoViewController<LoadingIndicatorViewDemoView>()
        case .refreshControl:
            return DemoViewController<RefreshControlDemoView>()
        case .horizontalSlide:
            let presentedViewController = HorizontalSlideDemoViewController()
            let secondViewController = NavigationController(rootViewController: presentedViewController)
            secondViewController.transitioningDelegate = presentedViewController.transition
            secondViewController.modalPresentationStyle = .custom
            return secondViewController
        case .bottomSheetMechanics:
            return BottomSheetMechanicsDemoViewController()
        case .feedbackView:
            return DemoViewController<FeedbackDemoView>(dismissType: .dismissButton)
        case .happinessRating:
            return DemoViewController<HappinessRatingDemoView>(dismissType: .dismissButton)
        case .earthHourView:
            return DemoViewController<EarthHourDemoView>()
        case .klimabroletView:
            return KlimabroletDemoViewController(dismissType: .none)
        case .christmasWishListView:
            return DemoViewController<ChristmasWishListDemoView>()
        case .nativeAdvert:
            return DemoViewController<NativeAdvertDemoView>(dismissType: .dismissButton)
        case .callout:
            return DemoViewController<CalloutDemoView>()
        case .detailCallout:
            return DemoViewController<DetailCalloutDemoView>()
        case .phaseList:
            return DemoViewController<PhaseListDemoView>()
        case .iconCollection:
            return DemoViewController<IconCollectionDemoView>()
        case .disclaimerView:
            return DemoViewController<DisclaimerDemoView>()
        case .questionnaireView:
            return DemoViewController<QuestionnaireDemoView>()
        case .tweakable:
            return DemoViewController<TweakableDemoView>()
        case .stepSlider:
            return DemoViewController<StepSliderDemoView>()
        case .verificationView:
            return DemoViewController<VerificationDemoView>()
        case .loanCalculatorView:
            return DemoViewController<LoanCalculatorDemoView>()
        case .panel:
            return DemoViewController<PanelDemoView>()
        case .visibilityDrivenTitleView:
            return DemoViewController<VisibilityDrivenTitleDemoView>(dismissType: .dismissButton)
        case .broadcast:
            return DemoViewController<BroadcastDemoView>()
        case .selectorTitleView:
            return DemoViewController<SelectorTitleViewDemoView>()
        case .priming:
            return DemoViewController<PrimingDemoView>(
                containmentOptions: .bottomSheet,
                constrainToBottomSafeArea: false
            )
        case .footerButtonView:
            return DemoViewController<FooterButtonDemoView>(constrainToBottomSafeArea: false)
        case .checkmarkTitleView:
            return DemoViewController<CheckmarkTitleViewDemoView>()
        case .viewingsListView:
            return DemoViewController<ViewingsListDemoView>()
        case .viewingsRedesignView:
            return DemoViewController<ViewingsRedesignDemoView>()
        case .selfDeclarationView:
            return DemoViewController<SelfDeclarationDemoView>()
        case .collapsibleContentView:
            return DemoViewController<CollapsibleContentDemoView>(dismissType: .dismissButton)
        case .columnListsView:
            return DemoViewController<ColumnListsDemoView>()
        case .keyValueGridView:
            return DemoViewController<KeyValueGridDemoView>()
//        case .objectPagePriceView:
//            return DemoViewController<ObjectPagePriceDemoView>()
        case .linkButtonListView:
            return DemoViewController<LinkButtonListDemoView>()
        case .safetyElementsView:
            return DemoViewController<SafetyElementsDemoView>(dismissType: .dismissButton)
        case .contractActionView:
            return DemoViewController<ContractActionDemoView>()
//        case .objectPageTitleView:
//            return DemoViewController<ObjectPageTitleDemoView>()
        case .favoriteButton:
            return DemoViewController<FavoriteButtonDemoView>(dismissType: .dismissButton)
        case .sendInviteView:
            return DemoViewController<SendInviteDemoView>(containmentOptions: .bottomSheet)
        case .navigationLinkView:
            return DemoViewController<NavigationLinkViewDemoView>()
        case .numberedListView:
            return DemoViewController<NumberedListDemoView>()
        case .transactionEntryView:
            return DemoViewController<TransactionEntryDemoView>()
        case .blockUserView:
            return DemoViewController<BlockUserDemoView>()
        case .loadingRetryView:
            return DemoViewController<LoadingRetryDemoView>()
        case .promotionView:
            return DemoViewController<PromotionDemoView>()
        case .frontPageSavedSearchesView:
            return DemoViewController<FrontPageSavedSearchesDemoView>()
        case .overFlowCollectionView:
            return DemoViewController<OverflowCollectionViewDemo>()
        case .scrollableTabDemoView:
            return DemoViewController<ScrollableTabDemoView>(dismissType: .dismissButton)
        case .monthAndYearPickerView:
            return DemoViewController<MonthAndYearPickerDemoView>()
        case .searchView:
            return DemoViewController<SearchDemoView>()
        case .addressComponentView:
            return DemoViewController<AddressComponentDemoView>(dismissType: .dismissButton)
        case .selectionListCheckboxView:
            return DemoViewController<SelectionListCheckboxDemoView>(dismissType: .dismissButton)
        case .selectionListRadiobuttonView:
            return DemoViewController<SelectionListRadiobuttonDemoView>(dismissType: .dismissButton)
        case .selectionListSeparatedRadiobuttonView:
            return DemoViewController<SelectionListSeparatedRadiobuttonDemoView>(dismissType: .dismissButton)
        case .badgeView:
            return DemoViewController<BadgeDemoView>()
        case .jobApplyBox:
            return DemoViewController<JobApplyBoxDemoView>(dismissType: .dismissButton)
        case .jobKeyInfo:
            return DemoViewController<JobKeyInfoDemoView>()
        case .myAdsListView:
            return DemoViewController<MyAdsListDemoView>(dismissType: .dismissButton, containmentOptions: .navigationController)
        case .brazePromotionView:
            return DemoViewController<BrazePromotionDemoView>()
        case .mapAddressButton:
            return DemoViewController<MapAddressButtonDemoView>(dismissType: .dismissButton)
        case .hyperlinkTextView:
            return DemoViewController<HyperlinkTextViewDemoView>()
        }
    }
}
