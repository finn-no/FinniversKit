import FinniversKit
import DemoKit

enum ComponentDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case addressCardView
    case addressComponentView
    case badgeView
    case bannerTransparencyView
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
    case frontPageTransactionListView
    case frontPageTransactionView
    case happinessRating
    case horizontalSlide
    case hyperlinkTextView
    case iconButton
    case iconCollection
    case infobox
    case infoboxSwiftUI
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
    case verificationView
    case viewingsListView
    case viewingsRedesignView
    case visibilityDrivenTitleView

    static var groupTitle: String { "Components" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    var groupItemTitle: String {
        switch self {
        case .selectionListCheckboxView:
            return "SelectionListView - checkboxes"
        case .selectionListRadiobuttonView:
            return "SelectionListView - radio buttons"
        case .selectionListSeparatedRadiobuttonView:
            return "SelectionListView - separated radio buttons"
        default:
            return rawValue.capitalizingFirstLetter
        }
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .addressCardView:
            return AddressCardDemoView()
        case .button:
            return ButtonDemoView()
        case .multilineButton:
            return MultilineButtonDemoView()
        case .floatingButton:
            return FloatingButtonDemoView()
        case .reviewButtonView:
            return ReviewButtonViewDemoView()
        case .cogWheelButton:
            return CogWheelButtonDemoView()
        case .iconButton:
            return IconButtonDemoView()
        case .label:
            return LabelDemoView()
        case .ribbon:
            return RibbonDemoView()
        case .textField:
            return TextFieldDemoView()
        case .textView:
            return TextViewDemoView()
        case .toast:
            return ToastDemoView()
        case .switchView:
            return SwitchViewDemoView()
        case .infobox:
            return InfoboxDemoView()
        case .infoboxSwiftUI:
            return InfoboxSwiftUIViewController()
        case .consentTransparencyInfo:
            return ConsentTransparencyInfoDemoView()
        case .bannerTransparencyView:
            return BannerTransparencyDemoView()
        case .checkbox:
            return CheckboxDemoView()
        case .radioButton:
            return RadioButtonDemoView()
        case .roundedImageView:
            return RoundedImageViewDemoView()
        case .loadingIndicator:
            return LoadingIndicatorViewDemoView()
        case .refreshControl:
            return RefreshControlDemoView()
        case .horizontalSlide:
            return HorizontalSlideDemoViewController()
        case .bottomSheetMechanics:
            return BottomSheetMechanicsDemoViewController()
        case .feedbackView:
            return FeedbackDemoView()
        case .happinessRating:
            return HappinessRatingDemoView()
        case .earthHourView:
            return EarthHourDemoView()
        case .klimabroletView:
            return KlimabroletDemoViewController()
        case .christmasWishListView:
            return ChristmasWishListDemoView()
        case .nativeAdvert:
            return NativeAdvertDemoView()
        case .callout:
            return CalloutDemoView()
        case .detailCallout:
            return DetailCalloutDemoView()
        case .phaseList:
            return PhaseListDemoView()
        case .iconCollection:
            return IconCollectionDemoView()
        case .disclaimerView:
            return DisclaimerDemoView()
        case .questionnaireView:
            return QuestionnaireDemoView()
        case .stepSlider:
            return StepSliderDemoView()
        case .verificationView:
            return VerificationDemoView()
        case .loanCalculatorView:
            return LoanCalculatorDemoView()
        case .panel:
            return PanelDemoView()
        case .visibilityDrivenTitleView:
            return VisibilityDrivenTitleDemoView()
        case .broadcast:
            return BroadcastDemoView()
        case .selectorTitleView:
            return SelectorTitleViewDemoView()
        case .priming:
            return PrimingDemoView()
        case .footerButtonView:
            return FooterButtonDemoView()
        case .checkmarkTitleView:
            return CheckmarkTitleViewDemoView()
        case .viewingsListView:
            return ViewingsListDemoView()
        case .viewingsRedesignView:
            return ViewingsRedesignDemoView()
        case .selfDeclarationView:
            return SelfDeclarationDemoView()
        case .collapsibleContentView:
            return CollapsibleContentDemoView()
        case .columnListsView:
            return ColumnListsDemoView()
        case .keyValueGridView:
            return KeyValueGridDemoView()
        case .linkButtonListView:
            return LinkButtonListDemoView()
        case .safetyElementsView:
            return SafetyElementsDemoView()
        case .contractActionView:
            return ContractActionDemoView()
        case .favoriteButton:
            return FavoriteButtonDemoView()
        case .sendInviteView:
            return SendInviteDemoView()
        case .navigationLinkView:
            return NavigationLinkViewDemoView()
        case .numberedListView:
            return NumberedListDemoView()
        case .transactionEntryView:
            return TransactionEntryDemoView()
        case .loadingRetryView:
            return LoadingRetryDemoView()
        case .promotionView:
            return PromotionDemoView()
        case .frontPageTransactionView:
            return FrontPageTransactionDemoViewController()
        case .frontPageTransactionListView:
            return FrontPageTransactionListDemoViewController()
        case .frontPageSavedSearchesView:
            return FrontPageSavedSearchesDemoView()
        case .overFlowCollectionView:
            return OverflowCollectionViewDemo()
        case .scrollableTabDemoView:
            return ScrollableTabDemoView()
        case .monthAndYearPickerView:
            return MonthAndYearPickerDemoView()
        case .searchView:
            return SearchDemoView()
        case .addressComponentView:
            return AddressComponentDemoView()
        case .selectionListCheckboxView:
            return SelectionListCheckboxDemoView()
        case .selectionListRadiobuttonView:
            return SelectionListRadiobuttonDemoView()
        case .selectionListSeparatedRadiobuttonView:
            return SelectionListSeparatedRadiobuttonDemoView()
        case .badgeView:
            return BadgeDemoView()
        case .jobApplyBox:
            return JobApplyBoxDemoView()
        case .jobKeyInfo:
            return JobKeyInfoDemoView()
        case .myAdsListView:
            return MyAdsListDemoView()
        case .brazePromotionView:
            return BrazePromotionDemoView()
        case .mapAddressButton:
            return MapAddressButtonDemoView()
        case .hyperlinkTextView:
            return HyperlinkTextViewDemoView()
        }
    }
}
