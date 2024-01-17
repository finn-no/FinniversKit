//
//  Copyright © 2018 FINN AS. All rights reserved.
//

@testable import Demo
import XCTest
import FinniversKit
import DemoKitSnapshot

@MainActor
class DnaViewTests: XCTestCase {
    private func snapshot(_ component: DnaDemoViews, record: Bool = false, line: UInt = #line) {
        snapshotTest(demoable: component.demoable, record: record, line: line)
    }

    // MARK: - Tests

    func testDnaViewsColor() {
        snapshot(.color)
    }

    func testDnaViewsFont() {
        snapshot(.font)
    }

    func testDnaViewsSpacing() {
        snapshot(.spacing)
    }
}
