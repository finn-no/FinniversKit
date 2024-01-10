//
//  Copyright © 2018 FINN AS. All rights reserved.
//

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

    func testHostingContentConfigurationCell() {
        snapshot(.hostingContentConfigurationCell)
    }
}
