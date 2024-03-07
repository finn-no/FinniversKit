import XCTest
import FinniversKit

final class HTMLStringParserTests: XCTestCase {
    struct HTMLTokenIdentityTranslator: HTMLStringParserTranslator {
        func translate(tokens: [HTMLToken]) throws -> [HTMLToken] {
            return tokens
        }
    }

    let translator = HTMLTokenIdentityTranslator()

    func testHTMLElementIncluded() throws {
        let html = "<html>Foo</html>"
        let htmlTokens: [HTMLToken] = [
            .tagStart(name: "html", attributes: [], isSelfClosing: false),
            .text("Foo"),
            .tagEnd(name: "html"),
        ]
        let tokens = try HTMLStringParser.parse(html: html, translator: translator)
        XCTAssertEqual(tokens, htmlTokens)
    }

    func testTokens() throws {
        let boldText = "This is a <b>bold</b> move"
        let boldTokens: [HTMLToken] = [
            .text("This is a "),
            .tagStart(name: "b", attributes: [], isSelfClosing: false),
            .text("bold"),
            .tagEnd(name: "b"),
            .text(" move"),
        ]
        let tokens = try HTMLStringParser.parse(html: boldText, translator: translator)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testTokensWithAttributes() throws {
        let boldText = "Attributed <b custom1=\"foo\" custom2=\"bar\">bold</b> element"
        let boldTokens: [HTMLToken] = [
            .text("Attributed "),
            .tagStart(name: "b", attributes: [
                .init(name: "custom1", value: "foo"),
                .init(name: "custom2", value: "bar"),
            ], isSelfClosing: false),
            .text("bold"),
            .tagEnd(name: "b"),
            .text(" element"),
        ]
        let tokens = try HTMLStringParser.parse(html: boldText, translator: translator)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testCommentToken() throws {
        let boldText = "This is a <b>bold</b><!-- Is it really? --> move"
        let boldTokens: [HTMLToken] = [
            .text("This is a "),
            .tagStart(name: "b", attributes: [], isSelfClosing: false),
            .text("bold"),
            .tagEnd(name: "b"),
            .comment(" Is it really? "),
            .text(" move"),
        ]
        let tokens = try HTMLStringParser.parse(html: boldText, translator: translator)
        XCTAssertEqual(tokens, boldTokens)
    }

    func testMixedOrder() throws {
        let html = #"<div><b></div><i></b></i>"#
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [], isSelfClosing: false),
            .tagStart(name: "b", attributes: [], isSelfClosing: false),
            .tagEnd(name: "div"),
            .tagStart(name: "i", attributes: [], isSelfClosing: false),
            .tagEnd(name: "b"),
            .tagEnd(name: "i"),
        ]
        let tokens = try HTMLStringParser.parse(html: html, translator: translator)
        XCTAssertEqual(tokens, reference)
    }
}
