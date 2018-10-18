//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import FBSnapshotTestCase
import FinniversKit

class RecyclingViewTests: FBSnapshotTestCase {
    static var allViews = RecyclingViews.all

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    override class func tearDown() {
        super.tearDown()

        if RecyclingViewTests.allViews.count > 0 {
            fatalError("Not all elements were implemented, missing: \(RecyclingViewTests.allViews.map { $0.rawValue }.joined(separator: ", "))")
        }
    }

    func snapshot(_ component: RecyclingViews) {
        FBSnapshotVerifyView(component.viewController.view)
        RecyclingViewTests.allViews = RecyclingViewTests.allViews.filter { $0 != component }
    }

    func testNotificationsListView() {
        snapshot(.notificationsListView)
    }

    func testMarketsGridView() {
        snapshot(.marketsGridView)
    }

    func testAdsGridView() {
        snapshot(.adsGridView)
    }

    func testFavoritesListView() {
        snapshot(.favoritesListView)
    }

    func testFavoriteFoldersListView() {
        snapshot(.favoriteFoldersListView)
    }

    func testSavedSearchesListView() {
        snapshot(.savedSearchesListView)
    }

    func testSettingsView() {
        snapshot(.settingsView)
    }
}
