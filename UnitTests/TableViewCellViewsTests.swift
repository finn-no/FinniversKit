//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class TableViewCellsViewTests: FBSnapshotTestCase {
    static var allViews = TableViewCellViews.allCases

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    override class func tearDown() {
        super.tearDown()

        if TableViewCellsViewTests.allViews.count > 0 {
            fatalError("Not all elements were implemented, missing: \(TableViewCellsViewTests.allViews.map { $0.rawValue }.joined(separator: ", "))")
        }
    }

    func snapshot(_ component: TableViewCellViews) {
        FBSnapshotVerifyView(component.viewController.view)
        TableViewCellsViewTests.allViews = TableViewCellsViewTests.allViews.filter { $0 != component }
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

    func testHeartSubtitleCell() {
        snapshot(.heartSubtitleCell)
    }

    func testIconTitleCell() {
        snapshot(.iconTitleCell)
    }
}
