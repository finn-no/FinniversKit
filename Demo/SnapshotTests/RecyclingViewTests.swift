@testable import Demo
import XCTest
import FinniversKit
import DemoKitSnapshot

class RecyclingViewTests: XCTestCase {
    private func snapshot(_ component: RecyclingDemoViews, record: Bool = true, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testNotificationsListView() {
       // snapshot(.notificationsListView)
    }

    func testMarketsGridView() {
        print("____TESTING MARKETGRID_____")
        snapshot(.marketsGridView)
    }

    func testAdRecommendationsGridView() {
       // snapshot(.adRecommendationsGridView)
    }

    func testFavoritesListView() {
       // snapshot(.favoritesListView)
    }

    func testFavoriteFoldersListView() {
       // snapshot(.favoriteFoldersListView)
    }

    func testSavedSearchesListView() {
       // snapshot(.savedSearchesListView)
    }

    func testSettingsView() {
       // snapshot(.settingsView)
    }

    func testAdManagementView() {
       // snapshot(.adManagementView)
    }

    func testNeighborhoodProfileView() {
        //snapshot(.neighborhoodProfileView)
    }

    func testBasicTableView() {
       // snapshot(.basicTableView)
    }

    func testCompactMarketsView() {
      //  snapshot(.compactMarketsView)
    }
}
