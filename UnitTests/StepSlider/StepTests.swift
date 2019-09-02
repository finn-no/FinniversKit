//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@testable import FinniversKit
import XCTest

final class StepTests: XCTestCase {
    func testIndex() {
        XCTAssertNil(Step.lowerBound.index)
        XCTAssertNil(Step.upperBound.index)
        XCTAssertEqual(Step.value(index: 0, rounded: false).index, 0)
        XCTAssertEqual(Step.value(index: 4, rounded: true).index, 4)
    }

    func testComparable() {
        let step = Step.value(index: 3, rounded: false)

        XCTAssertFalse(Step.lowerBound < Step.lowerBound)
        XCTAssertTrue(Step.lowerBound < step)
        XCTAssertTrue(Step.lowerBound < Step.upperBound)

        XCTAssertFalse(step < step)
        XCTAssertFalse(step < Step.lowerBound)
        XCTAssertTrue(step < Step.upperBound)
        XCTAssertTrue(step < Step.value(index: 3, rounded: true))
        XCTAssertFalse(Step.value(index: 3, rounded: true) < step)

        XCTAssertFalse(Step.upperBound < Step.upperBound)
        XCTAssertFalse(Step.upperBound < step)
        XCTAssertFalse(Step.upperBound < Step.lowerBound)
    }
}
