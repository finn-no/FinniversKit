//
//  Copyright © FINN.no AS. All rights reserved.
//

import XCTest
import FinniversKit

final class ButtonTests: XCTestCase {
    /// Warp 1.1.1+ caches token providers, so building the same preset style twice
    /// gives styles that hold the same `UIColor` instances and compare equal.
    /// `setTitle` must still set a plain title and give the button a size.
    func testSetTitleSetsTitleAndSizeForEveryPresetStyle() {
        let styles: [(name: String, style: Button.Style)] = [
            ("default", .default),
            ("utility", .utility),
            ("callToAction", .callToAction),
            ("destructive", .destructive),
            ("flat", .flat),
            ("destructiveFlat", .destructiveFlat),
            ("link", .link),
        ]

        for (name, style) in styles {
            let button = Button(style: style)
            button.setTitle("Read more", for: .normal)

            XCTAssertEqual(button.title(for: .normal), "Read more", "style: \(name)")
            XCTAssertNotEqual(button.intrinsicContentSize, .zero, "style: \(name)")
        }
    }
}
