//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import XCTest
import FinniversKit

class FinniversKitTests: XCTestCase {
    @available(iOS 13.0, *)
    func testDefaultValueForInterfaceStyle() {
        let defaultValue: FinniversKit.UserInterfaceStyleSupport = .dynamic
        XCTAssertEqual(FinniversKit.userInterfaceStyleSupport, defaultValue)
    }

    func testOverridingValueForInterfaceStyle() {
        FinniversKit.userInterfaceStyleSupport = .forceDark
        XCTAssertEqual(
            FinniversKit.userInterfaceStyleSupport,
            FinniversKit.UserInterfaceStyleSupport.forceDark
        )
    }
}
