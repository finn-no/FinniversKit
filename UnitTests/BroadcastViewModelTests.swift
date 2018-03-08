//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

@testable import FinniversKit
import XCTest

class BroadcastViewModelTests: XCTestCase {
    func testBroadcastViewModelCanFindHTMLLinksInMessage() {
        // Given
        let linkURL = "https://www.finn.no"
        let linkText = "Besøk oss på vår nettside"
        let link = "<a href=\"\(linkURL)\">\(linkText)</a>"
        let testMessage = "Dette er en melding som inneholder en link \(link)"
        let rangeOfLink = testMessage.range(of: link)

        // When
        let viewModel = BroadcastViewModel(with: testMessage)
        let htmLinkInMessage = viewModel.htmlLinksInMessage.first

        // Then
        XCTAssertNotNil(htmLinkInMessage)
        XCTAssertEqual(htmLinkInMessage?.range, rangeOfLink)
        XCTAssertEqual(htmLinkInMessage?.text, linkText)
        XCTAssertEqual(htmLinkInMessage?.url.absoluteString, linkURL)
    }

    func testBroadcastViewModelCanFindMultipleHTMLLinksInMessage() {
        // Given
        let firstLinkURL = "https://www.finn.no"
        let firstLinkText = "Besøk oss på vår nettside"
        let firstLink = "<a href=\"\(firstLinkURL)\">\(firstLinkText)</a>"

        let secondLinkURL = "www.aftenposten.no"
        let secondLinkText = "Aftenposten"
        let secondLink = "<a href=\"\(secondLinkURL)\">\(secondLinkText)</a>"

        let testMessage = "Dette er en melding som inneholder to linker \(firstLink) \(secondLink)"
        let rangeOfFirstLink = testMessage.range(of: firstLink)
        let rangeOfLastLink = testMessage.range(of: secondLink)

        // When
        let viewModel = BroadcastViewModel(with: testMessage)
        let firstHTTMLinkInMessage = viewModel.htmlLinksInMessage.first
        let secondHTTMLinkInMessage = viewModel.htmlLinksInMessage.last

        // Then
        XCTAssertNotNil(firstHTTMLinkInMessage)
        XCTAssertEqual(firstHTTMLinkInMessage?.range, rangeOfFirstLink)
        XCTAssertEqual(firstHTTMLinkInMessage?.text, firstLinkText)
        XCTAssertEqual(firstHTTMLinkInMessage?.url.absoluteString, firstLinkURL)

        XCTAssertNotNil(secondHTTMLinkInMessage)
        XCTAssertEqual(secondHTTMLinkInMessage?.range, rangeOfLastLink)
        XCTAssertEqual(secondHTTMLinkInMessage?.text, secondLinkText)
        XCTAssertEqual(secondHTTMLinkInMessage?.url.absoluteString, secondLinkURL)
    }

    func testBroadcastViewModelCanFindHTMLLinksInMessageWhenLinkSyntaxHasIncorrectSpacings() {
        // Given
        let linkURL = "https://www.finn.no"
        let linkText = " Besøk oss på vår nettside "
        let linkWithIncorrectSpacings = "< a href = \"\(linkURL)\" >\(linkText)< /a >"
        let testMessage = "Dette er en melding som inneholder en link \(linkWithIncorrectSpacings)"
        let rangeOfLink = testMessage.range(of: linkWithIncorrectSpacings)

        // When
        let viewModel = BroadcastViewModel(with: testMessage)
        let htmLinkInMessage = viewModel.htmlLinksInMessage.first

        // Then
        XCTAssertNotNil(htmLinkInMessage)
        XCTAssertEqual(htmLinkInMessage?.range, rangeOfLink)
        XCTAssertEqual(htmLinkInMessage?.text, linkText)
        XCTAssertEqual(htmLinkInMessage?.url.absoluteString, linkURL)
    }

    func testBroadcastViewModelCanReplaceHTMLLinkWithAttributedStringWithLinkAttrbutes() {
        // Given
        let linkURL = URL(string: "https://www.finn.no")!
        let linkText = "Besøk oss på vår nettside"
        let link = "<a href=\"\(linkURL.absoluteString)\">\(linkText)</a>"
        let testMessage = "Dette er en melding som inneholder en link \(link)"

        // When
        let viewModel = BroadcastViewModel(with: testMessage)
        let expectedResult = "Dette er en melding som inneholder en link \(linkText)"
        let result = viewModel.messageWithHTMLLinksReplacedByAttributedStrings
        let linkTextRangeInResult = NSString(string: result.string).range(of: linkText)
        let attributes = result.attributes(at: linkTextRangeInResult.location, longestEffectiveRange: nil, in: linkTextRangeInResult)

        // Then
        XCTAssertEqual(result.string, expectedResult)
        XCTAssertNotNil(attributes[NSAttributedStringKey.link])
        XCTAssertEqual(attributes[NSAttributedStringKey.link] as? URL, linkURL)
    }
}
