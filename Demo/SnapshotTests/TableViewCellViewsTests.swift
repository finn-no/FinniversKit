import FinniversKit
import XCTest
@testable import Demo
import DemoKitSnapshot

@MainActor
class TableViewCellsViewTests: XCTestCase {
    private func snapshot(_ component: CellsDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: CellsDemoViews.self) {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

    func testBasicCell() {
        snapshot(.basicCell, record: true)
    }

    func testBasicCellVariations() {
        snapshot(.basicCellVariations, record: true)
    }

    func testCheckboxCell() {
        snapshot(.checkboxCell, record: true)
    }

    func testCheckboxSubtitleCell() {
        snapshot(.checkboxSubtitleCell, record: true)
    }

    func testRadioButtonCell() {
        snapshot(.radioButtonCell, record: true)
    }

    func testHeartSubtitleCell() {
        snapshot(.heartSubtitleCell, record: true)
    }

    func testIconTitleCell() {
        snapshot(.iconTitleCell, record: true)
    }

    func testRemoteImageCell() {
        snapshot(.remoteImageCell, record: true)
    }

    func testFavoriteAdCell() {
        snapshot(.favoriteAdCell)
    }

    func testHostingContentConfigurationCell() {
        snapshot(.hostingContentConfigurationCell)
    }
}
