//
//  Copyright © 2018 FINN AS. All rights reserved.
//

@testable import Demo
import XCTest
import SwiftUI
import DemoKitSnapshot

class SwiftUIViewTests: XCTestCase {
    private func snapshot(_ component: SwiftUIDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testCheckBox() {
        snapshot(.checkBox)
    }

    func testHTMLText() {
        snapshot(.htmlText)
    }

    func testIconButton() {
        snapshot(.iconButton)
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
}
