@testable import Demo
import XCTest
import FinniversKit
import DemoKitSnapshot

@MainActor
class RecyclingViewTests: XCTestCase {
    private func snapshot(_ component: RecyclingDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testNotificationsListView() {
        snapshot(.notificationsListView)
    }

    func testAdRecommendationsGridView() {
        snapshot(.adRecommendationsGridView)
    }

    func testFavoritesListView() {
        snapshot(.favoritesListView)
    }

    func testFavoriteFoldersListView() {
        snapshot(.favoriteFoldersListView, record: true)
    }

    func testSavedSearchesListView() {
        snapshot(.savedSearchesListView)
    }

    func testSettingsView() {
        snapshot(.settingsView, record: true)
    }

    func testNeighborhoodProfileView() {
        snapshot(.neighborhoodProfileView)
    }

    func testBasicTableView() {
        snapshot(.basicTableView)
    }
}
