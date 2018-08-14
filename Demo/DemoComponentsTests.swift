//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class DemoComponentsTests: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    // MARK: - Components

    // MARK: Selection Boxes
    func testRadioButtonDemoView() {
        let controller = ViewController<RadioButtonDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    func testCheckboxDemoView() {
        let controller = ViewController<CheckboxDemoView>()
        FBSnapshotVerifyView(controller.view)
    }


    // MARK: Consents
    func testConsentTransparencyInfoDemoView() {
        let controller = ViewController<ConsentTransparencyInfoDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    func testInlineConsentDemoView() {
        let controller = ViewController<InlineConsentDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Switch
    func testSwitchViewDemoView() {
        let controller = ViewController<SwitchViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Broadcasts
//    func testBroadcastDemoView() {
//        let controller = ViewController<BroadcastDemoView>()
//        FBSnapshotVerifyView(controller.view)
//    }

    func testBroadcastContainerDemoView() {
        let controller = ViewController<BroadcastContainerDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Button
    func testButtonDemoView() {
        let controller = ViewController<ButtonDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Label
    func testLabelDemoView() {
        let controller = ViewController<LabelDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Ribbon
    func testRibbonDemoView() {
        let controller = ViewController<RibbonDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: TextField
    func testTextFieldDemoView() {
        let controller = ViewController<TextFieldDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Toast
    func testToastDemoView() {
        let controller = ViewController<ToastDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: RoundedImageView
    func testRoundedImageViewDemoView() {
        let controller = ViewController<RoundedImageViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: - Fullscreens

    // MARK: AdReporter
    func testAdReporterDemoView() {
        let controller = ViewController<AdReporterDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Frontpage
    func testFrontpageViewDemoView() {
        let controller = ViewController<FrontpageViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    //  MARK: Popup
    func testPopupViewDemoView() {
        let controller = ViewController<PopupViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Review
    func testReviewViewDemoView() {
        let controller = ViewController<ReviewViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

    // MARK: Empty
    func testEmptyViewDemoView() {
        let controller = ViewController<EmptyViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }
}
