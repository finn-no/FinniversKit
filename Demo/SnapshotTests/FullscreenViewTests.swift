//
//  Copyright © 2018 FINN AS. All rights reserved.
//

@testable import Demo
import XCTest
import FinniversKit
import DemoKitSnapshot

class FullscreenViewTests: XCTestCase {
    private func snapshot(_ component: FullscreenDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

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

    func testVerificationActionSheet() {
        snapshot(.verificationActionSheet)
    }

    func testSettingDetails() {
        snapshot(.settingDetails)
    }

    func testFavoriteAdActionView() {
        snapshot(.favoriteAdActionView)
    }

    func testFavoriteAdCommentInputView() {
        snapshot(.favoriteAdCommentInputView)
    }

    func testFavoriteFolderActionView() {
        snapshot(.favoriteFolderActionView)
    }

    func testBetaFeatureView() {
        snapshot(.betaFeatureView)
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

    func testMessageUserRequiredSheet() {
        snapshot(.messageUserRequiredSheet)
    }
}
