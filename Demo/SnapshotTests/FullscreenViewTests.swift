//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import XCTest
import FinniversKit

class FullscreenViewTests: XCTestCase {
    private let excludedComponents: [FullscreenDemoViews] = [.pianoView]

    private func snapshot(_ component: FullscreenDemoViews, includeIPad: Bool = false, delay: TimeInterval? = nil, record: Bool = false, testName: String = #function) {
        assertSnapshots(matching: component.viewController, includeDarkMode: true, includeIPad: includeIPad, delay: delay, record: record, testName: testName)
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

    func testMotorTransactionView() {
        snapshot(.motorTransactionView)
    }

    func testMotorTransactionInvalidUserView() {
        snapshot(.motorTransactionInvalidUserView)
    }

    func testMotorTransactionInviteCounterpartyView() {
        snapshot(.motorTransactionInviteCounterpartyView)
    }

    func testResultView() {
        snapshot(.resultView)
    }

    func testFavoriteSold() {
        snapshot(.favoriteSold)
    }

    func testConfettiView() {
        snapshot(.confettiView)
    }

    func testSearchResultsView() {
        snapshot(.searchResultsView)
    }

    func testSavedSearchSortingView() {
        snapshot(.savedSearchSortingView)
    }

    func testSearchDisplayTypeSelectionView() {
        snapshot(.searchDisplayTypeSelectionView)
    }

    func testMessageUserRequiredSheet() {
        snapshot(.messageUserRequiredSheet)
    }

    func testMotorTransactionInsurancePickerView() {
        snapshot(.motorTransactionInsurancePickerView)
    }

    func testMotorTransactionInsuranceConfirmationView() {
        snapshot(.motorTransactionInsuranceConfirmationView)
    }
}
