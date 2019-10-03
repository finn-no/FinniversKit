//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import XCTest
import SnapshotTesting
import FinniversKit

class ComponentViewTests: XCTestCase {
    private func snapshot(_ component: ComponentDemoViews, testName: String = #function) {
        assertSnapshot(matching: component.viewController, as: .image(on: .iPhoneX), named: "iPhone", testName: testName)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: ComponentDemoViews.self) {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

    func testButton() {
        snapshot(.button)
    }

    func testDialogue() {
        snapshot(.dialogue)
    }

    func testEasterEggButton() {
        snapshot(.easterEggButton)
    }

    func testCogWheelButton() {
        snapshot(.cogWheelButton)
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

    func testInlineConsent() {
        snapshot(.inlineConsent)
    }

    func testInlineConsentV2() {
        snapshot(.inlineConsentV2)
    }

    func testConsentTransparencyInfo() {
        snapshot(.consentTransparencyInfo)
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

    func testNewYearsView() {
        snapshot(.newYearsView)
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

    func testEarthHourView() {
        snapshot(.earthHourView)
    }

    func testStepIndicatorView() {
        snapshot(.stepIndicatorView)
    }

    func testNativeAdverts() {
        snapshot(.nativeAdverts)
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

    func testIdentityView() {
        snapshot(.identityView)
    }

    func testDisclaimerView() {
        snapshot(.disclaimerView)
    }

    func testQuestionnaireView() {
      snapshot(.questionnaireView)
    }

    func testTweakable() {
        snapshot(.tweakable)
    }

    func testKlimabroletView() {
        snapshot(.klimabroletView)
    }

    func testSaveSearchView() {
        snapshot(.saveSearchView)
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

    func testReputationView() {
        snapshot(.reputationView)
    }

    func testVisibilityDrivenTitleView() {
        snapshot(.visibilityDrivenTitleView)
    }
}
