//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import XCTest
import FinniversKit

class ConfigTests: XCTestCase {
    @available(iOS 13.0, *)
    func testDefaultValueForInterfaceStyle() {
        XCTAssertEqual(Config.userInterfaceStyleSupport, .dynamic)
    }

    func testOverridingValueForInterfaceStyle() {
        Config.userInterfaceStyleSupport = .forceDark
        XCTAssertEqual(Config.userInterfaceStyleSupport, .forceDark)
    }

    func testDynamicTypeEnabled() {
        XCTAssertTrue(Config.isDynamicTypeEnabled)
    }
}
