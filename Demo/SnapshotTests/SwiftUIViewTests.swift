//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import XCTest
import SwiftUI

class SwiftUIViewTests: XCTestCase {
    private func snapshot(
        _ component: SwiftUIDemoViews,
        includeIPad: Bool = false,
        delay: TimeInterval? = nil,
        record: Bool = false,
        testName: String = #function
    ) {
        assertSnapshots(matching: component.viewController, includeDarkMode: true, includeIPad: includeIPad, delay: delay, record: record, testName: testName)
    }

    // MARK: - Tests

    func testMissingSnapshotTests() {
        for element in elementWithoutTests(for: SwiftUIDemoViews.self) {
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

    func testHTMLText() {
        snapshot(.htmlText)
    }

    func testTextField() {
        snapshot(.textField)
    }

    func testTextView() {
        snapshot(.textView)
    }
}
