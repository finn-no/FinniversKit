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
            // Skip LoadingSwiftUIView snapshot since deterministic capture of animation is currently not possible
            if element == .loadingView { continue }
            XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
        }
    }

    func testCheckBox() {
        snapshot(.checkBox)
    }

    func testHTMLText() {
        snapshot(.htmlText)
    }

    func testLoadingIndicator() {
        snapshot(.loadingIndicator)
    }

    func testRadioButton() {
        snapshot(.radioButton)
    }

    func testSelectionListView() {
        snapshot(.selectionListView)
    }

    func testTextField() {
        snapshot(.textField)
    }

    func testTextView() {
        snapshot(.textView)
    }

    func testToast() {
        snapshot(.toast)
    }

    func testResultView() {
        snapshot(.resultView)
    }

    func testFloatingButton() {
        snapshot(.floatingButton)
    }
}
