//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@testable import FinniversKit
import XCTest

class BroadcastModelTests: XCTestCase {
    func testBroadcastModelCanReplaceHTMLLinkWithAttributedStringWithLinkAttrbutes() {
        // Given
        let linkURL = URL(string: "https://www.finn.no/")!
        let linkText = "Besøk oss på vår nettside"
        let link = "<a href=\"\(linkURL.absoluteString)\" title=\"some title\" target=\"\">\(linkText)</a>"
        let testMessage = "Dette er en melding som inneholder en link \(link)"

        // When
        let viewModel = BroadcastModel(with: testMessage)
        let expectedResult = "Dette er en melding som inneholder en link \(linkText)"
        let result = viewModel.messageWithHTMLLinksReplacedByAttributedStrings
        let resultRange = NSMakeRange(0, result.string.count)
        let linkTextRangeInResult = NSString(string: result.string).range(of: linkText)

        // Then
        XCTAssertEqual(result.string, expectedResult)

        for location in resultRange.lowerBound ..< resultRange.upperBound {
            let attributes = result.attributes(at: location, longestEffectiveRange: nil, in: resultRange)
            if linkTextRangeInResult.contains(location) {
                XCTAssertNotNil(attributes[NSAttributedStringKey.link])
                XCTAssertEqual(attributes[NSAttributedStringKey.link] as? URL, linkURL)
            } else {
                XCTAssertNil(attributes[NSAttributedStringKey.link])
            }
        }
    }
}
