import XCTest
import FinniversKit
@testable import Demo
import DemoKitSnapshot

@MainActor
class ComponentViewTests: XCTestCase {
    private func snapshot(_ component: ComponentDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(
            demoable: component.demoable,
            record: record,
            precision: 0.98,
            line: line
        )
    }

    // MARK: - Tests

    func testAddressCardView() {
        snapshot(.addressCardView)
    }

    func testButton() {
        snapshot(.button)
    }

    func testMultilineButton() {
        snapshot(.multilineButton)
    }

    func testFloatingButton() {
        snapshot(.floatingButton)
    }

    func testCogWheelButton() {
        snapshot(.cogWheelButton)
    }

    func testIconButton() {
        snapshot(.iconButton)
    }

    func testLabel() {
        snapshot(.label)
    }

    func testRibbon() {
        snapshot(.ribbon)
    }

    func testTextField() {
        snapshot(.textField)
    }

    func testTextView() {
        snapshot(.textView)
    }

    func testToast() {
        snapshot(.toast)
    }

    func testSwitchView() {
        snapshot(.switchView)
    }

    func testCheckbox() {
        snapshot(.checkbox)
    }

    func testRadioButton() {
        snapshot(.radioButton)
    }

    func testRoundedImageView() {
        snapshot(.roundedImageView)
    }

    func testReviewButtonView() {
        snapshot(.reviewButtonView)
    }

    func testLoadingIndicator() {
        snapshot(.loadingIndicator)
    }

    func testRefreshControl() {
        snapshot(.refreshControl)
    }

    func testHorizontalSlide() {
        snapshot(.horizontalSlide)
    }

    func testBannerTransparencyView() {
        snapshot(.bannerTransparencyView)
    }

    func testBottomSheetMechanics() {
        snapshot(.bottomSheetMechanics)
    }

    func testInfobox() {
        snapshot(.infobox)
    }

    func testFeedbackView() {
        snapshot(.feedbackView)
    }

    func testHappinessRating() {
        snapshot(.happinessRating)
    }

    func testNativeAdvert() {
        snapshot(.nativeAdvert)
    }

    func testCallout() {
        snapshot(.callout)
    }

    func testPhaseList() {
        snapshot(.phaseList)
    }

    func testIconCollection() {
        snapshot(.iconCollection)
    }

    func testDisclaimerView() {
        snapshot(.disclaimerView)
    }

    func testQuestionnaireView() {
      snapshot(.questionnaireView)
    }

    func testStepSlider() {
        snapshot(.stepSlider)
    }

    func testVerificationView() {
        snapshot(.verificationView)
    }

    func testPanel() {
        snapshot(.panel)
    }

    func testLoanCalculatorView() {
        snapshot(.loanCalculatorView)
    }

    func testVisibilityDrivenTitleView() {
        snapshot(.visibilityDrivenTitleView)
    }

    func testPriming() {
        snapshot(.priming)
    }

    func testSelectorTitleView() {
        snapshot(.selectorTitleView)
    }

    func testFooterButtonView() {
        snapshot(.footerButtonView)
    }

    func testBroadcast() {
        snapshot(.broadcast)
    }

    func testCheckmarkTitleView() {
        snapshot(.checkmarkTitleView)
    }

    func testSelfDeclarationView() {
        snapshot(.selfDeclarationView)
    }

    func testCollapsibleContentView() {
        snapshot(.collapsibleContentView)
    }

    func testViewingsListView() {
        snapshot(.viewingsListView)
    }

    func testViewingsRedesignView() {
        snapshot(.viewingsRedesignView)
    }

    func testColumnListsView() {
        snapshot(.columnListsView)
    }

    func testKeyValueGridView() {
        snapshot(.keyValueGridView)
    }

    func testLinkButtonListView() {
        snapshot(.linkButtonListView)
    }

    func testSafetyElementsView() {
        snapshot(.safetyElementsView)
    }

    func testContractActionView() {
        snapshot(.contractActionView)
    }

    func testFavoriteButton() {
        snapshot(.favoriteButton)
    }

    func testSendInviteView() {
        snapshot(.sendInviteView)
    }

    func testNavigationLinkView() {
        snapshot(.navigationLinkView)
    }

    func testNumberedListView() {
        snapshot(.numberedListView)
    }

    func testLoadingRetryView() {
        snapshot(.loadingRetryView)
    }

    func testPromotionView() {
        snapshot(.promotionView)
    }

    func testFrontPageSavedSearchesView() {
        snapshot(.frontPageSavedSearchesView)
    }

    func testOverflowCollectionView() {
        snapshot(.overFlowCollectionView)
    }

    func testDetailCallout() {
        snapshot(.detailCallout)
    }

    func testScrollableTabDemoView() {
        snapshot(.scrollableTabDemoView)
    }

    func testMonthAndYearPickerView() {
        snapshot(.monthAndYearPickerView)
    }

    func testSearchView() {
        snapshot(.searchView)
    }

    func testSelectionListCheckboxView() {
        snapshot(.selectionListCheckboxView)
    }

    func testSelectionListRadiobuttonView() {
        snapshot(.selectionListRadiobuttonView)
    }

    func testSelectionListSeparatedRadiobuttonView() {
        snapshot(.selectionListSeparatedRadiobuttonView)
    }

    func testAddressComponentView() {
        snapshot(.addressComponentView)
    }

    func testBadgeView() {
        snapshot(.badgeView)
    }

    func testJobApplyBox() {
        snapshot(.jobApplyBox)
    }

    func testJobKeyInfo() {
        snapshot(.jobKeyInfo)
    }

    func testMapAddressButton() {
        snapshot(.mapAddressButton)
    }

    func testHyperlinkTextView() {
        snapshot(.hyperlinkTextView)
    }
}
