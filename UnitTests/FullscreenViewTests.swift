//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import FBSnapshotTestCase
import FinniversKit

class FullscreenViewTests: FBSnapshotTestCase {
    private let excludedComponents: [FullscreenDemoViews] = [.pianoView]

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func snapshot(_ component: FullscreenDemoViews) {
        FBSnapshotVerifyView(component.viewController.view)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: FullscreenDemoViews.self) where !excludedComponents.contains(element) {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
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
        snapshot(.drumMachineView)
    }

    func testSnowGlobeView() {
        snapshot(.snowGlobeView)
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

    func testMessageFormView() {
        snapshot(.messageFormView)
    }

    func testLoginEntryView() {
        snapshot(.loginEntryView)
    }

    func testReceiptView() {
        snapshot(.receiptView)
    }

    func testAddressView() {
        snapshot(.addressView)
    }

    func testFavoriteAdsList() {
        snapshot(.favoriteAdsList)
    }

    func testSearchResultMapView() {
        snapshot(.searchResultMapView)
    }

    func testFavoriteFolderActionSheet() {
        snapshot(.favoriteFolderActionSheet)
    }

    func testFavoriteAdSortingSheet() {
        snapshot(.favoriteAdSortingSheet)
    }

    func testFavoriteAdActionSheet() {
        snapshot(.favoriteAdActionSheet)
    }

    func testFavoriteAdCommentSheet() {
        snapshot(.favoriteAdCommentSheet)
    }

    func testVerificationActionSheet() {
        snapshot(.verificationActionSheet)
    }

    func testSplashView() {
        snapshot(.splashView)
    }
}
