//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Demo
import XCTest
import SwiftUI
@testable import FinnUI

@available(iOS 13.0, *)
class SwiftUIViewTests: XCTestCase {
    private func snapshot<T: PreviewProvider>(
        _ provider: T.Type,
        includeIPad: Bool = false,
        delay: TimeInterval? = nil,
        testName: String = #function
    ) {
        let controller = UIHostingController(rootView: T.previews)
        assertSnapshots(matching: controller, includeDarkMode: true, includeIPad: includeIPad, delay: delay, testName: testName)
    }

    // MARK: - Tests

    func testSettingsPreview() {
        snapshot(SettingsView_Previews.self)
    }
}
