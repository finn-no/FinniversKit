//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class DnaViewTests: FBSnapshotTestCase {
    static var allViews = DnaViews.all

    override func setUp() {
        super.setUp()
        recordMode = true
    }

    override class func tearDown() {
        super.tearDown()

        if DnaViewTests.allViews.count > 0 {
            fatalError("Not all elements were implemented, missing: \(DnaViewTests.allViews.map { $0.rawValue }.joined(separator: ", "))")
        }
    }

    func snapshot(_ component: DnaViews) {
        FBSnapshotVerifyView(component.viewController.view)
        DnaViewTests.allViews = DnaViewTests.allViews.filter { $0 != component }
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
