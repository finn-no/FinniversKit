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

    private func snapshot(_ component: DnaDemoViews) {
        FBSnapshotVerifyView(component.viewController.view)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: DnaDemoViews.self, testMethodPrefix: "testDnaDemoViews") {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

    func testDnaDemoViewsColor() {
        snapshot(.color)
    }

    func testDnaDemoViewsFont() {
        snapshot(.font)
    }

    func testDnaDemoViewsSpacing() {
        snapshot(.spacing)
    }

    func testDnaDemoViewsAssets() {
        snapshot(.assets)
    }
}
