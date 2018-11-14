//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import FBSnapshotTestCase
import FinniversKit

class FullscreenViewTests: FBSnapshotTestCase {
    static var allViews = FullscreenViews.allCases

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    override class func tearDown() {
        super.tearDown()

        if FullscreenViewTests.allViews.count > 0 {
            fatalError("Not all elements were implemented, missing: \(FullscreenViewTests.allViews.map { $0.rawValue }.joined(separator: ", "))")
        }
    }

    func snapshot(_ component: FullscreenViews) {
        FBSnapshotVerifyView(component.viewController.view)
        FullscreenViewTests.allViews = FullscreenViewTests.allViews.filter { $0 != component }
    }

    func testFrontpageView() {
        snapshot(.frontpageView)
    }

    func testPopupView() {
        snapshot(.popupView)
    }

    func testEmptyView() {
        snapshot(.emptyView)
    }

    func testReportAdView() {
        snapshot(.reportAdView)
    }

    func testReviewView() {
        snapshot(.reviewView)
    }

    func testRegisterView() {
        snapshot(.registerView)
    }

    func testLoginView() {
        snapshot(.loginView)
    }

    func testDrumMachineView() {
        snapshot(.drumMachine)
    }

    func testLoadingView() {
        snapshot(.loadingView)
    }

    func testConsentToggleView() {
        snapshot(.consentToggleView)
    }

    func testConsentActionView() {
        snapshot(.consentActionView)
    }
}
