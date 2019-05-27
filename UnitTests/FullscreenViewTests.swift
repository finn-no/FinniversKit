//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import FBSnapshotTestCase
import FinniversKit

class FullscreenViewTests: FBSnapshotTestCase {
    static var allViews = FullscreenViews.allCases
    private let excludedComponents: [FullscreenViews] = [.piano]

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
        FullscreenViewTests.allViews = FullscreenViewTests.allViews.filter {
            $0 != component && !excludedComponents.contains($0)
        }
    }

    func testFrontpageView() {
        snapshot(.frontPageView)
    }

    func testPopupView() {
        snapshot(.popupView)
    }

    func testEmptyView() {
        snapshot(.emptyView)
    }

    func testEmptyChristmasView() {
        snapshot(.emptyChristmasView)
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

    func testSnowGlobeView() {
        snapshot(.snowGlobe)
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

    func testSoldView() {
        snapshot(.soldView)
    }

    func testConfirmationView() {
        snapshot(.confirmationView)
    }

    func testFullscreenGallery() {
        snapshot(.fullscreenGallery)
    }

    func testContactFormView() {
        snapshot(.contactFormView)
    }
}
