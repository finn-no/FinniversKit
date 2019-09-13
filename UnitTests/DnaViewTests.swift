//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import FBSnapshotTestCase
import FinniversKit

class DnaViewTests: FBSnapshotTestCase {
    static var allViews = DnaViews.items

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    override class func tearDown() {
        super.tearDown()

        if DnaViewTests.allViews.count > 0 {
            fatalError("Not all elements were implemented, missing: \(DnaViewTests.allViews.map { $0.rawValue }.joined(separator: ", "))")
        }
    }

    private func snapshot(_ component: DnaViews) {
        FBSnapshotVerifyView(component.viewController.view)
        DnaViewTests.allViews = DnaViewTests.allViews.filter { $0 != component }
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
