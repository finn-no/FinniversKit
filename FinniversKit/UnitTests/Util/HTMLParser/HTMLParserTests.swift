import XCTest
import FinniversKit

final class HTMLParserTests: XCTestCase {
    let parser = HTMLStringParser()

    func testHTMLElementIncluded() throws {
        let html = "<html>Foo</html>"
        let htmlTokens: [HTMLStringLexer.Token] = [
            .beginTag(name: "html", attributes: [:], isSelfClosing: false),
            .text("Foo"),
            .endTag(name: "html"),
        ]
        let tokens = parser.tokenize(html: html)
        XCTAssertEqual(tokens, htmlTokens)
    }

    func testTokens() throws {
        let boldText = "This is a <b>bold</b> move"
        let boldTokens: [HTMLStringLexer.Token] = [
            .text("This is a "),
            .beginTag(name: "b", attributes: [:], isSelfClosing: false),
            .text("bold"),
            .endTag(name: "b"),
            .text(" move"),
        ]
        let tokens = parser.tokenize(html: boldText)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testTokensWithAttributes() throws {
        let boldText = "Attributed <b custom1=\"foo\" custom2=\"bar\">bold</b> element"
        let boldTokens: [HTMLStringLexer.Token] = [
            .text("Attributed "),
            .beginTag(name: "b", attributes: [
                "custom1": "foo",
                "custom2": "bar"
            ], isSelfClosing: false),
            .text("bold"),
            .endTag(name: "b"),
            .text(" element"),
        ]
        let tokens = parser.tokenize(html: boldText)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testCommentToken() throws {
        let boldText = "This is a <b>bold</b><!-- Is it really? --> move"
        let boldTokens: [HTMLStringLexer.Token] = [
            .text("This is a "),
            .beginTag(name: "b", attributes: [:], isSelfClosing: false),
            .text("bold"),
            .endTag(name: "b"),
            .commentTag(text: " Is it really? "),
            .text(" move"),
        ]
        let tokens = parser.tokenize(html: boldText)
        XCTAssertEqual(tokens, boldTokens)
    }
}
