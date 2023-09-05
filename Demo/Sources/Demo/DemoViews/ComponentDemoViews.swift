import FinniversKit

public enum ComponentDemoViews: String, DemoViews {
    case addressCardView
    case addressComponentView
    case badgeView
    case bannerTransparencyView
    case blockUserView
    case bottomSheetMechanics
    case brazePromotionView
    case broadcast
    case button
    case callout
    case checkbox
    case checkmarkTitleView
    case christmasWishListView
    case cogWheelButton
    case collapsibleContentView
    case columnListsView
    case consentTransparencyInfo
    case contractActionView
    case detailCallout
    case disclaimerView
    case earthHourView
    case favoriteButton
    case feedbackView
    case floatingButton
    case footerButtonView
    case frontPageSavedSearchesView
    case frontPageTransactionFeed
    case happinessRating
    case horizontalSlide
    case hyperlinkTextView
    case iconButton
    case iconCollection
    case infobox
    case jobApplyBox
    case jobKeyInfo
    case keyValueGridView
    case klimabroletView
    case label
    case linkButtonListView
    case loadingIndicator
    case loadingRetryView
    case loanCalculatorView
    case mapAddressButton
    case monthAndYearPickerView
    case multilineButton
    case myAdsListView
    case nativeAdvert
    case navigationLinkView
    case numberedListView
    case overFlowCollectionView
    case panel
    case phaseList
    case priming
    case promotionView
    case questionnaireView
    case radioButton
    case refreshControl
    case reviewButtonView
    case ribbon
    case roundedImageView
    case safetyElementsView
    case scrollableTabDemoView
    case searchView
    case selectionListCheckboxView
    case selectionListRadiobuttonView
    case selectionListSeparatedRadiobuttonView
    case selectorTitleView
    case selfDeclarationView
    case sendInviteView
    case stepSlider
    case switchView
    case textField
    case textView
    case toast
    case transactionEntryView
    case tweakable
    case verificationView
    case viewingsListView
    case viewingsRedesignView
    case visibilityDrivenTitleView

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
        case .addressComponentView:
            return DemoViewController<AddressComponentDemoView>(dismissType: .dismissButton)
        case .badgeView:
            return DemoViewController<BadgeDemoView>()
        case .bannerTransparencyView:
            return DemoViewController<BannerTransparencyDemoView>(containmentOptions: .bottomSheet)
        case .blockUserView:
            return DemoViewController<BlockUserDemoView>()
        case .bottomSheetMechanics:
            return BottomSheetMechanicsDemoViewController()
        case .brazePromotionView:
            return DemoViewController<BrazePromotionDemoView>()
        case .broadcast:
            return DemoViewController<BroadcastDemoView>()
        case .button:
            return DemoViewController<ButtonDemoView>()
        case .callout:
            return DemoViewController<CalloutDemoView>()
        case .checkbox:
            return DemoViewController<CheckboxDemoView>(dismissType: .dismissButton)
        case .checkmarkTitleView:
            return DemoViewController<CheckmarkTitleViewDemoView>()
        case .christmasWishListView:
            return DemoViewController<ChristmasWishListDemoView>()
        case .cogWheelButton:
            return DemoViewController<CogWheelButtonDemoView>()
        case .collapsibleContentView:
            return DemoViewController<CollapsibleContentDemoView>(dismissType: .dismissButton)
        case .columnListsView:
            return DemoViewController<ColumnListsDemoView>()
        case .consentTransparencyInfo:
            return DemoViewController<ConsentTransparencyInfoDemoView>()
        case .contractActionView:
            return DemoViewController<ContractActionDemoView>()
        case .detailCallout:
            return DemoViewController<DetailCalloutDemoView>()
        case .disclaimerView:
            return DemoViewController<DisclaimerDemoView>()
        case .earthHourView:
            return DemoViewController<EarthHourDemoView>()
        case .favoriteButton:
            return DemoViewController<FavoriteButtonDemoView>(dismissType: .dismissButton)
        case .feedbackView:
            return DemoViewController<FeedbackDemoView>(dismissType: .dismissButton)
        case .floatingButton:
            return DemoViewController<FloatingButtonDemoView>()
        case .footerButtonView:
            return DemoViewController<FooterButtonDemoView>(constrainToBottomSafeArea: false)
        case .frontPageSavedSearchesView:
            return DemoViewController<FrontPageSavedSearchesDemoView>()
        case .frontPageTransactionFeed:
            return DemoViewController<FrontPageTransactionDemoView>()
        case .happinessRating:
            return DemoViewController<HappinessRatingDemoView>(dismissType: .dismissButton)
        case .horizontalSlide:
            let presentedViewController = HorizontalSlideDemoViewController()
            let secondViewController = NavigationController(rootViewController: presentedViewController)
            secondViewController.transitioningDelegate = presentedViewController.transition
            secondViewController.modalPresentationStyle = .custom
            return secondViewController
        case .hyperlinkTextView:
            return DemoViewController<HyperlinkTextViewDemoView>()
        case .iconButton:
            return DemoViewController<IconButtonDemoView>()
        case .iconCollection:
            return DemoViewController<IconCollectionDemoView>()
        case .infobox:
            return DemoViewController<InfoboxDemoView>()
        case .jobApplyBox:
            return DemoViewController<JobApplyBoxDemoView>(dismissType: .dismissButton)
        case .jobKeyInfo:
            return DemoViewController<JobKeyInfoDemoView>()
        case .keyValueGridView:
            return DemoViewController<KeyValueGridDemoView>()
        case .klimabroletView:
            return KlimabroletDemoViewController(dismissType: .none)
        case .label:
            return DemoViewController<LabelDemoView>()
        case .linkButtonListView:
            return DemoViewController<LinkButtonListDemoView>()
        case .loadingIndicator:
            return DemoViewController<LoadingIndicatorViewDemoView>()
        case .loadingRetryView:
            return DemoViewController<LoadingRetryDemoView>()
        case .loanCalculatorView:
            return DemoViewController<LoanCalculatorDemoView>()
        case .mapAddressButton:
            return DemoViewController<MapAddressButtonDemoView>(dismissType: .dismissButton)
        case .monthAndYearPickerView:
            return DemoViewController<MonthAndYearPickerDemoView>()
        case .multilineButton:
            return DemoViewController<MultilineButtonDemoView>()
        case .myAdsListView:
            return DemoViewController<MyAdsListDemoView>(dismissType: .dismissButton, containmentOptions: .navigationController)
        case .nativeAdvert:
            return DemoViewController<NativeAdvertDemoView>(dismissType: .dismissButton)
        case .navigationLinkView:
            return DemoViewController<NavigationLinkViewDemoView>()
        case .numberedListView:
            return DemoViewController<NumberedListDemoView>()
        case .overFlowCollectionView:
            return DemoViewController<OverflowCollectionViewDemo>()
        case .panel:
            return DemoViewController<PanelDemoView>()
        case .phaseList:
            return DemoViewController<PhaseListDemoView>()
        case .priming:
            return DemoViewController<PrimingDemoView>(
                containmentOptions: .bottomSheet,
                constrainToBottomSafeArea: false
            )
        case .promotionView:
            return DemoViewController<PromotionDemoView>()
        case .questionnaireView:
            return DemoViewController<QuestionnaireDemoView>()
        case .radioButton:
            return DemoViewController<RadioButtonDemoView>(dismissType: .dismissButton)
        case .refreshControl:
            return DemoViewController<RefreshControlDemoView>()
        case .reviewButtonView:
            return DemoViewController<ReviewButtonViewDemoView>()
        case .ribbon:
            return DemoViewController<RibbonDemoView>()
        case .roundedImageView:
            return DemoViewController<RoundedImageViewDemoView>()
        case .safetyElementsView:
            return DemoViewController<SafetyElementsDemoView>(dismissType: .dismissButton)
        case .scrollableTabDemoView:
            return DemoViewController<ScrollableTabDemoView>(dismissType: .dismissButton)
        case .searchView:
            return DemoViewController<SearchDemoView>()
        case .selectionListCheckboxView:
            return DemoViewController<SelectionListCheckboxDemoView>(dismissType: .dismissButton)
        case .selectionListRadiobuttonView:
            return DemoViewController<SelectionListRadiobuttonDemoView>(dismissType: .dismissButton)
        case .selectionListSeparatedRadiobuttonView:
            return DemoViewController<SelectionListSeparatedRadiobuttonDemoView>(dismissType: .dismissButton)
        case .selectorTitleView:
            return DemoViewController<SelectorTitleViewDemoView>()
        case .selfDeclarationView:
            return DemoViewController<SelfDeclarationDemoView>()
        case .sendInviteView:
            return DemoViewController<SendInviteDemoView>(containmentOptions: .bottomSheet)
        case .stepSlider:
            return DemoViewController<StepSliderDemoView>()
        case .switchView:
            return DemoViewController<SwitchViewDemoView>()
        case .textField:
            return DemoViewController<TextFieldDemoView>()
        case .textView:
            return DemoViewController<TextViewDemoView>()
        case .toast:
            return DemoViewController<ToastDemoView>()
        case .transactionEntryView:
            return DemoViewController<TransactionEntryDemoView>()
        case .tweakable:
            return DemoViewController<TweakableDemoView>()
        case .verificationView:
            return DemoViewController<VerificationDemoView>()
        case .viewingsListView:
            return DemoViewController<ViewingsListDemoView>()
        case .viewingsRedesignView:
            return DemoViewController<ViewingsRedesignDemoView>()
        case .visibilityDrivenTitleView:
            return DemoViewController<VisibilityDrivenTitleDemoView>(dismissType: .dismissButton)
        }
    }
}
