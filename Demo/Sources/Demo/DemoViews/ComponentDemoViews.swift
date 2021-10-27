//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum ComponentDemoViews: String, DemoViews {
    case addressCardView
    case button
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
    case stepIndicatorView
    case nativeAdvert
    case callout
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
    case viewingsView
    case selfDeclarationView
    case collapsibleContentView
    case columnListsView
    case keyValueGridView
    case objectPagePriceView
    case linkButtonListView
    case safetyElementsView
    case contractActionView
    case objectPageTitleView
    case favoriteButton
    case sendInviteView
    case navigationLinkView
    case promoLinkView
    case promoSlidesView
    case numberedListView
    case transactionEntryView
    case blockUserView
    case loadingRetryView
    case promotionView

    public var viewController: UIViewController {
        switch self {
        case .addressCardView:
            return DemoViewController<AddressCardDemoView>()
        case .button:
            return DemoViewController<ButtonDemoView>()
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
        case .stepIndicatorView:
            return DemoViewController<StepIndicatorDemoView>(dismissType: .dismissButton)
        case .nativeAdvert:
            return DemoViewController<NativeAdvertDemoView>(dismissType: .dismissButton)
        case .callout:
            return DemoViewController<CalloutDemoView>()
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
        case .viewingsView:
            return DemoViewController<ViewingsDemoView>()
        case .selfDeclarationView:
            return DemoViewController<SelfDeclarationDemoView>()
        case .collapsibleContentView:
            return DemoViewController<CollapsibleContentDemoView>(dismissType: .dismissButton)
        case .columnListsView:
            return DemoViewController<ColumnListsDemoView>()
        case .keyValueGridView:
            return DemoViewController<KeyValueGridDemoView>()
        case .objectPagePriceView:
            return DemoViewController<ObjectPagePriceDemoView>()
        case .linkButtonListView:
            return DemoViewController<LinkButtonListDemoView>()
        case .safetyElementsView:
            return DemoViewController<SafetyElementsDemoView>(dismissType: .dismissButton)
        case .contractActionView:
            return DemoViewController<ContractActionDemoView>()
        case .objectPageTitleView:
            return DemoViewController<ObjectPageTitleDemoView>()
        case .favoriteButton:
            return DemoViewController<FavoriteButtonDemoView>(dismissType: .dismissButton)
        case .sendInviteView:
            return DemoViewController<SendInviteDemoView>(containmentOptions: .bottomSheet)
        case .navigationLinkView:
            return DemoViewController<NavigationLinkViewDemoView>()
        case .promoLinkView:
            return DemoViewController<PromoLinkDemoView>()
        case .promoSlidesView:
            return DemoViewController<PromoSlidesDemoView>()
        case .numberedListView:
            return DemoViewController<NumberedListDemoView>()
        case .transactionEntryView:
            return DemoViewController<TransactionEntryDemoView>()
        case .blockUserView:
            return DemoViewController<BlockUserDemoView>()
        case .loadingRetryView:
            return DemoViewController<LoadingRetryDemoView>()
        case .promotionView:
            return DemoViewController<ChristmasPromotionDemoView>()
        }
    }
}
