//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class TableViewCellsViewTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func snapshot(_ component: Cells) {
        FBSnapshotVerifyView(component.viewController.view)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: Cells.self) {
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
