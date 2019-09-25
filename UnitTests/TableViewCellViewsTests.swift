//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FinniversKit
import XCTest
import SnapshotTesting
import Demo

class TableViewCellsViewTests: XCTestCase {
    private func snapshot(_ component: CellsDemoViews, testName: String = #function) {
        assertSnapshot(matching: component.viewController, as: .image(on: .iPhoneX), named: "iPhone", testName: testName)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: CellsDemoViews.self) {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

    func testBasicCell() {
        snapshot(.basicCell)
    }

    func testBasicCellVariations() {
        snapshot(.basicCellVariations)
    }

    func testCheckboxCell() {
        snapshot(.checkboxCell)
    }

    func testCheckboxSubtitleCell() {
        snapshot(.checkboxSubtitleCell)
    }

    func testRadioButtonCell() {
        snapshot(.radioButtonCell)
    }

    func testHeartSubtitleCell() {
        snapshot(.heartSubtitleCell)
    }

    func testIconTitleCell() {
        snapshot(.iconTitleCell)
    }

    func testRemoteImageCell() {
        snapshot(.remoteImageCell)
    }

    func testFavoriteAdCell() {
        snapshot(.favoriteAdCell)
    }
}
