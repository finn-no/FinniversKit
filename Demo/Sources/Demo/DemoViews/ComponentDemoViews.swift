//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit
import DemoKit

enum Components: String, CaseIterable, DemoGroup, DemoGroupItem {
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
    case linkButtonListView
    case safetyElementsView
    case contractActionView
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

    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    var title: String {
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
        case .blockUserView:
            return BlockUserDemoView()
        case .loadingRetryView:
            return LoadingRetryDemoView()
        case .promotionView:
            return PromotionDemoView()
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
