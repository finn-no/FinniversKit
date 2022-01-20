//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import XCTest
import FinniversKit

class ConfigTests: XCTestCase {
    func testDynamicTypeEnabled() {
        XCTAssertTrue(Config.isDynamicTypeEnabled)
    }
}
