//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@testable import FinniversKit
import XCTest

class BroadcastMessageTests: XCTestCase {
    func testBroadcastModelCanReplaceHTMLLinkWithAttributedStringWithLinkAttrbutes() {
        // Given
        let linkURL = URL(string: "https://www.finn.no/")! // swiftlint:disable:this force_unwrapping
        let linkText = "Besøk oss på vår nettside"
        let link = "<a href=\"\(linkURL.absoluteString)\" title=\"some title\" target=\"\">\(linkText)</a>"
        let testMessage = "Dette er en melding som inneholder en link \(link)"

        // When
        let broadcastMessage = BroadcastMessage(id: 0, text: testMessage)
        let expectedResult = "Dette er en melding som inneholder en link \(linkText)"
        let result = broadcastMessage.attributedString(for: testMessage)
        let resultRange = NSRange(location: 0, length: result.string.count)
        let linkTextRangeInResult = NSString(string: result.string).range(of: linkText)

        // Then
        XCTAssertEqual(result.string, expectedResult)

        for location in resultRange.lowerBound ..< resultRange.upperBound {
            let attributes = result.attributes(at: location, longestEffectiveRange: nil, in: resultRange)
            if linkTextRangeInResult.contains(location) {
                XCTAssertNotNil(attributes[NSAttributedString.Key.link])
                XCTAssertEqual(attributes[NSAttributedString.Key.link] as? URL, linkURL)
            } else {
                XCTAssertNil(attributes[NSAttributedString.Key.link])
            }
        }
    }
}
