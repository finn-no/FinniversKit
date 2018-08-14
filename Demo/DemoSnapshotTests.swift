//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class DnaViewTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testDnaViewsColor() {
        snapshot(.color)
    }

    func testDnaViewsFont() {
        snapshot(.font)
    }

    func testDnaViewsSpacing() {
        snapshot(.spacing)
    }

    func testDnaViewsAssets() {
        snapshot(.assets)
    }
}

class ComponentViewTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testComponentViewBroadcast() {
        snapshot(.broadcast)
    }

    func testComponentViewBroadcastContainer() {
        snapshot(.broadcastContainer)
    }

    func testComponentViewButton() {
        snapshot(.button)
    }

    func testComponentViewLabel() {
        snapshot(.label)
    }

    func testComponentViewRibbon() {
        snapshot(.ribbon)
    }

    func testComponentViewTextField() {
        snapshot(.textField)
    }

    func testComponentViewToast() {
        snapshot(.toast)
    }

    func testComponentViewSwitchView() {
        snapshot(.switchView)
    }

    func testComponentViewInlineConsent() {
        snapshot(.inlineConsent)
    }

    func testComponentViewConsentTransparencyInfo() {
        snapshot(.consentTransparencyInfo)
    }

    func testComponentViewCheckbox() {
        snapshot(.checkbox)
    }

    func testComponentViewRadioButton() {
        snapshot(.radioButton)
    }

    func testComponentViewRoundedImageView() {
        snapshot(.roundedImageView)
    }
}

class RecyclingViewTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testRecyclingViewNotificationsListView() {
        snapshot(.notificationsListView)
    }

    func testRecyclingViewMarketsGridView() {
        snapshot(.marketsGridView)
    }

    func testRecyclingViewAdsGridView() {
        snapshot(.adsGridView)
    }
}

class FullscreenViewTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testFullscreenViewFrontpageView() {
        snapshot(.frontpageView)
    }

    func testFullscreenViewPopupView() {
        snapshot(.popupView)
    }

    func testFullscreenViewEmptyView() {
        snapshot(.emptyView)
    }

    func testFullscreenViewReportAdView() {
        snapshot(.reportAdView)
    }

    func testFullscreenViewReviewView() {
        snapshot(.reviewView)
    }
}
