//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@testable import FinniversKit
import XCTest

final class ArrayStepTests: XCTestCase {
    private let values = [100, 200, 400]

    // MARK: - Tests

    func testClosestStepForValue() {
        XCTAssertEqual(values.closestStep(for: 80), .lowerBound)
        XCTAssertEqual(values.closestStep(for: 100), .value(index: 0, rounded: false))
        XCTAssertEqual(values.closestStep(for: 200), .value(index: 1, rounded: false))
        XCTAssertEqual(values.closestStep(for: 400), .value(index: 2, rounded: false))
        XCTAssertEqual(values.closestStep(for: 350), .value(index: 1, rounded: true))
        XCTAssertEqual(values.closestStep(for: 500), .upperBound)
    }

    func testValueForStep() {
        XCTAssertNil(values.value(for: .lowerBound))
        XCTAssertNil(values.value(for: .upperBound))
        XCTAssertEqual(values.value(for: .value(index: 0, rounded: false)), 100)
        XCTAssertEqual(values.value(for: .value(index: 1, rounded: false)), 200)
        XCTAssertEqual(values.value(for: .value(index: 2, rounded: false)), 400)
        XCTAssertEqual(values.value(for: .value(index: 1, rounded: true)), 200)
        XCTAssertEqual(values.closestStep(for: 500), .upperBound)
    }
}
