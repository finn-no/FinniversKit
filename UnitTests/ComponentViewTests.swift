//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import FBSnapshotTestCase
import FinniversKit

class ComponentViewTests: FBSnapshotTestCase {
    static var allViews = ComponentViews.items

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    override class func tearDown() {
        super.tearDown()

        if ComponentViewTests.allViews.count > 0 {
            fatalError("Not all elements were implemented, missing: \(ComponentViewTests.allViews.map { $0.rawValue }.joined(separator: ", "))")
        }
    }

    func snapshot(_ component: ComponentViews) {
        FBSnapshotVerifyView(component.viewController.view)
        ComponentViewTests.allViews = ComponentViewTests.allViews.filter { $0 != component }
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
        snapshot(.bannerTransparency)
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
        snapshot(.earthHour)
    }

    func testStepIndicatorView() {
        snapshot(.stepIndicator)
    }

    func testNativeAdverts() {
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
        snapshot(.klimabrolet)
    }

    func testSaveSearchView() {
        snapshot(.saveSearchView)
    }

    func testStepSlider() {
        snapshot(.stepSlider)
    }
}
