//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@testable import FinniversKit
import XCTest

class LayoutHelpersTests: XCTestCase {
    func testEdgeInsets() {
        let inset = Insets(top: 10, leading: 10, bottom: 10, trailing: 10)
        XCTAssertEqual(inset.top, 10)
        XCTAssertEqual(inset.leading, 10)
        XCTAssertEqual(inset.bottom, -10)
        XCTAssertEqual(inset.trailing, -10)
    }
}
