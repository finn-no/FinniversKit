//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import FBSnapshotTestCase
import FinniversKit

class DnaViewTests: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    private func snapshot(_ component: DnaViews) {
        FBSnapshotVerifyView(component.viewController.view)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: DnaViews.self, testMethodPrefix: "testDnaViews") {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
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
