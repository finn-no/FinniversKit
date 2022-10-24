import XCTest
import FinniversKit

final class HTMLParserTests: XCTestCase {
    let parser = HTMLParser()

    func testHTMLElementIncluded() throws {
        let html = "<html>Foo</html>"
        let htmlTokens: [HTMLParser.Token] = [
            .elementBegin(name: "html", attributes: [:]),
            .text("Foo"),
            .elementEnd(name: "html"),
        ]
        let tokens = try parser.tokenize(html: html)
        XCTAssertEqual(tokens, htmlTokens)
    }

    func testTokens() throws {
        let boldText = "This is a <b>bold</b> move"
        let boldTokens: [HTMLParser.Token] = [
            .elementBegin(name: "html", attributes: [:]),
            .text("This is a "),
            .elementBegin(name: "b", attributes: [:]),
            .text("bold"),
            .elementEnd(name: "b"),
            .text(" move"),
            .elementEnd(name: "html"),
        ]
        let tokens = try parser.tokenize(html: boldText)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testTokensWithAttributes() throws {
        let boldText = "Attributed <b custom1=\"foo\" custom2=\"bar\">bold</b> element"
        let boldTokens: [HTMLParser.Token] = [
            .elementBegin(name: "html", attributes: [:]),
            .text("Attributed "),
            .elementBegin(name: "b", attributes: [
                "custom1": "foo",
                "custom2": "bar"
            ]),
            .text("bold"),
            .elementEnd(name: "b"),
            .text(" element"),
            .elementEnd(name: "html"),
        ]
        let tokens = try parser.tokenize(html: boldText)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testCommentToken() throws {
        let boldText = "This is a <b>bold</b><!-- Is it really? --> move"
        let boldTokens: [HTMLParser.Token] = [
            .elementBegin(name: "html", attributes: [:]),
            .text("This is a "),
            .elementBegin(name: "b", attributes: [:]),
            .text("bold"),
            .elementEnd(name: "b"),
            .comment(" Is it really? "),
            .text(" move"),
            .elementEnd(name: "html"),
        ]
        let tokens = try parser.tokenize(html: boldText)
        XCTAssertEqual(tokens, boldTokens)
    }
}
