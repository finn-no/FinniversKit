//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class ComponentViewTests: FBSnapshotTestCase {
    static var allViews = ComponentViews.all

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

    func testBroadcast() {
        snapshot(.broadcast)
    }

    func testBroadcastContainer() {
        snapshot(.broadcastContainer)
    }

    func testButton() {
        snapshot(.button)
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

    func testToast() {
        snapshot(.toast)
    }

    func testSwitchView() {
        snapshot(.switchView)
    }

    func testInlineConsent() {
        snapshot(.inlineConsent)
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
}
