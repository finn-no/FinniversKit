//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import XCTest
import FinniversKit

class FullscreenViewTests: XCTestCase {
    private let excludedComponents: [FullscreenDemoViews] = [.pianoView]

    private func snapshot(_ component: FullscreenDemoViews, includeIPad: Bool = false, testName: String = #function) {
        assertSnapshots(matching: component.viewController, includeDarkMode: true, includeIPad: includeIPad, testName: testName)
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

    func testBuyerPickerView() {
        snapshot(.buyerPickerView)
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

    func testAddressMapView() {
        snapshot(.addressMapView)
    }

    func testFavoriteAdsList() {
        snapshot(.favoriteAdsList)
    }

    func testSearchResultMapView() {
        snapshot(.searchResultMapView)
    }

    func testSplashView() {
        snapshot(.splashView)
    }

    func testVerificationActionSheet() {
        snapshot(.verificationActionSheet)
    }

    func testSettingDetails() {
        snapshot(.settingDetails)
    }

    func testNewYearsView() {
        snapshot(.newYearsView)
    }

    func testAdConfirmationView() {
        snapshot(.adConfirmationView)
    }

    func testFavoriteAdActionView() {
        snapshot(.favoriteAdActionView)
    }

    func testFavoriteAdCommentInputView() {
        snapshot(.favoriteAdCommentInputView)
    }

    func testFavoriteAdSortingView() {
        snapshot(.favoriteAdSortingView)
    }

    func testFavoriteFolderActionView() {
        snapshot(.favoriteFolderActionView)
    }

    func testBetaFeatureView() {
        snapshot(.betaFeatureView)
    }

    func testMinFinnView() {
        snapshot(.minFinnView)
    }

    func testNotificationCenterView() {
        snapshot(.notificationCenterView)
    }

    func testTransactionStepView() {
        snapshot(.transactionStepView)
    }

    func testErrorView() {
        snapshot(.errorView)
    }
}
