//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import XCTest
import SnapshotTesting
import FinniversKit

class DnaViewTests: XCTestCase {
    private func snapshot(_ component: DnaDemoViews, testName: String = #function) {
        assertSnapshot(matching: component.viewController, as: .image(on: .iPhoneX), named: "iPhone", testName: testName)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: DnaDemoViews.self, testMethodPrefix: "testDnaViews") {
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
