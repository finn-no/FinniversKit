//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FinniversKit
import XCTest
import Demo

class TableViewCellsViewTests: XCTestCase {
    private func snapshot(_ component: CellsDemoViews, includeIPad: Bool = false, delay: TimeInterval? = nil, record: Bool = false, testName: String = #function) {
        assertSnapshots(matching: component.viewController, includeDarkMode: true, includeIPad: includeIPad, delay: delay, record: record, testName: testName)
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

    func testUserAdCell() {
        snapshot(.userAdCell)
    }

    func testUserAdEmphasizedActionCell() {
        snapshot(.userAdEmphasizedActionCell)
    }
}
