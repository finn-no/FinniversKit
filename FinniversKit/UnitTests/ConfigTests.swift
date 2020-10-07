//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import XCTest
import FinniversKit

class ConfigTests: XCTestCase {
    @available(iOS 13.0, *)
    func testDefaultValueForInterfaceStyle() {
        let defaultValue: Config.UserInterfaceStyleSupport = .dynamic
        XCTAssertEqual(Config.userInterfaceStyleSupport, defaultValue)
    }

    func testOverridingValueForInterfaceStyle() {
        Config.userInterfaceStyleSupport = .forceDark
        XCTAssertEqual(
            Config.userInterfaceStyleSupport,
            Config.UserInterfaceStyleSupport.forceDark
        )
    }

    func testDynamicTypeEnabled() {
        XCTAssertTrue(Config.isDynamicTypeEnabled)
    }
}
