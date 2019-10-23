//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit

public enum ComponentDemoViews: String, CaseIterable {
    case button
    case dialogue
    case floatingButton
    case cogWheelButton
    case label
    case ribbon
    case textField
    case textView
    case toast
    case switchView
    case infobox
    case inlineConsent
    case inlineConsentV2
    case consentTransparencyInfo
    case bannerTransparencyView
    case checkbox
    case radioButton
    case roundedImageView
    case loadingIndicator
    case refreshControl
    case reviewButtonView
    case horizontalSlide
    case newYearsView
    case bottomSheetMechanics
    case feedbackView
    case happinessRating
    case earthHourView
    case klimabroletView
    case christmasWishListView
    case stepIndicatorView
    case nativeAdverts
    case callout
    case phaseList
    case iconCollection
    case disclaimerView
    case questionnaireView
    case tweakable
    case saveSearchView
    case identityView
    case stepSlider
    case loanCalculatorView
    case verificationView
    case panel
    case reputationView
    case visibilityDrivenTitleView
    case selectorTitleView

    public static var items: [ComponentDemoViews] {
        return allCases.sorted { $0.rawValue < $1.rawValue }
    }

    public var viewController: UIViewController {
        switch self {
        case .button:
            return DemoViewControllerContainer<ButtonDemoView>()
        case .dialogue:
            return DemoViewControllerContainer<DialogueDemoView>()
        case .floatingButton:
            return DemoViewControllerContainer<FloatingButtonDemoView>()
        case .reviewButtonView:
            return DemoViewControllerContainer<ReviewButtonViewDemoView>()
        case .cogWheelButton:
            return DemoViewControllerContainer<CogWheelButtonDemoView>()
        case .label:
            return DemoViewControllerContainer<LabelDemoView>()
        case .ribbon:
            return DemoViewControllerContainer<RibbonDemoView>()
        case .textField:
            return DemoViewControllerContainer<TextFieldDemoView>()
        case .textView:
            return DemoViewControllerContainer<TextViewDemoView>()
        case .toast:
            return DemoViewControllerContainer<ToastDemoView>()
        case .switchView:
            return DemoViewControllerContainer<SwitchViewDemoView>()
        case .infobox:
            return DemoViewControllerContainer<InfoboxDemoView>()
        case .inlineConsent:
            return DemoViewControllerContainer<InlineConsentDemoView>()
        case .inlineConsentV2:
            return InlineConsentDemoViewController()
        case .consentTransparencyInfo:
            return DemoViewControllerContainer<ConsentTransparencyInfoDemoView>()
        case .bannerTransparencyView:
            return DemoViewControllerContainer<BannerTransparencyDemoView>(containmentOptions: .bottomSheet)
        case .checkbox:
            return DemoViewControllerContainer<CheckboxDemoView>(dismissType: .dismissButton)
        case .radioButton:
            return DemoViewControllerContainer<RadioButtonDemoView>(dismissType: .dismissButton)
        case .roundedImageView:
            return DemoViewControllerContainer<RoundedImageViewDemoView>()
        case .loadingIndicator:
            return DemoViewControllerContainer<LoadingIndicatorViewDemoView>()
        case .refreshControl:
            return DemoViewControllerContainer<RefreshControlDemoView>()
        case .horizontalSlide:
            let presentedViewController = HorizontalSlideDemoViewController()
            let secondViewController = NavigationController(rootViewController: presentedViewController)
            secondViewController.transitioningDelegate = presentedViewController.transition
            secondViewController.modalPresentationStyle = .custom
            return secondViewController
        case .newYearsView:
            return DemoViewControllerContainer<NewYearsDemoView>()
        case .bottomSheetMechanics:
            return BottomSheetMechanicsDemoViewController()
        case .feedbackView:
            return DemoViewControllerContainer<FeedbackDemoView>(dismissType: .dismissButton)
        case .happinessRating:
            return DemoViewControllerContainer<HappinessRatingDemoView>(dismissType: .dismissButton)
        case .earthHourView:
            return DemoViewControllerContainer<EarthHourDemoView>()
        case .klimabroletView:
            return KlimabroletDemoViewController(dismissType: .none)
        case .christmasWishListView:
            return DemoViewControllerContainer<ChristmasWishListDemoView>()
        case .stepIndicatorView:
            return DemoViewControllerContainer<StepIndicatorDemoView>(dismissType: .dismissButton)
        case .nativeAdverts:
            return DemoViewControllerContainer<NativeAdvertDemoView>(dismissType: .dismissButton)
        case .callout:
            return DemoViewControllerContainer<CalloutDemoView>()
        case .phaseList:
            return DemoViewControllerContainer<PhaseListDemoView>()
        case .iconCollection:
            return DemoViewControllerContainer<IconCollectionDemoView>()
        case .disclaimerView:
            return DemoViewControllerContainer<DisclaimerDemoView>()
        case .questionnaireView:
            return DemoViewControllerContainer<QuestionnaireDemoView>()
        case .tweakable:
            return DemoViewControllerContainer<TweakableDemoView>()
        case .saveSearchView:
            return SaveSearchViewDemoViewController(containmentOptions: [.bottomSheet, .navigationController])
        case .identityView:
            return DemoViewControllerContainer<IdentityDemoView>()
        case .stepSlider:
            return DemoViewControllerContainer<StepSliderDemoView>()
        case .verificationView:
            return DemoViewControllerContainer<VerificationDemoView>()
        case .loanCalculatorView:
            return DemoViewControllerContainer<LoanCalculatorDemoView>()
        case .panel:
            return DemoViewControllerContainer<PanelDemoView>()
        case .reputationView:
            return DemoViewControllerContainer<ReputationDemoView>()
        case .visibilityDrivenTitleView:
            return DemoViewControllerContainer<VisibilityDrivenTitleDemoView>(dismissType: .dismissButton)
        case .selectorTitleView:
            return DemoViewControllerContainer<SelectorTitleViewDemoView>()
        }
    }
}
