import XCTest
import FinniversKit

final class HTMLStringParserTests: XCTestCase {
    let parser = HTMLStringParser()

    func testHTMLElementIncluded() throws {
        let html = "<html>Foo</html>"
        let htmlTokens: [HTMLLexer.Token] = [
            .startTag(name: "html", attributes: [:], isSelfClosing: false),
            .text("Foo"),
            .endTag(name: "html"),
        ]
        let tokens = parser.tokenize(html: html)
        XCTAssertEqual(tokens, htmlTokens)
    }

    func testTokens() throws {
        let boldText = "This is a <b>bold</b> move"
        let boldTokens: [HTMLLexer.Token] = [
            .text("This is a "),
            .startTag(name: "b", attributes: [:], isSelfClosing: false),
            .text("bold"),
            .endTag(name: "b"),
            .text(" move"),
        ]
        let tokens = parser.tokenize(html: boldText)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testTokensWithAttributes() throws {
        let boldText = "Attributed <b custom1=\"foo\" custom2=\"bar\">bold</b> element"
        let boldTokens: [HTMLLexer.Token] = [
            .text("Attributed "),
            .startTag(name: "b", attributes: [
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
        let boldTokens: [HTMLLexer.Token] = [
            .text("This is a "),
            .startTag(name: "b", attributes: [:], isSelfClosing: false),
            .text("bold"),
            .endTag(name: "b"),
            .commentTag(" Is it really? "),
            .text(" move"),
        ]
        let tokens = parser.tokenize(html: boldText)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testMixedOrder() throws {
        let html = #"<div><b></div><i></b></i>"#
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "div", attributes: [:], isSelfClosing: false),
            .startTag(name: "b", attributes: [:], isSelfClosing: false),
            .endTag(name: "div"),
            .startTag(name: "i", attributes: [:], isSelfClosing: false),
            .endTag(name: "b"),
            .endTag(name: "i"),
        ]
        let tokens = parser.tokenize(html: html)
        XCTAssertEqual(tokens, reference)
    }
}
