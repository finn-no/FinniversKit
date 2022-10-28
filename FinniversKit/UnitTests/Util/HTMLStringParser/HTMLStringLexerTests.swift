import XCTest
@testable import FinniversKit

final class HTMLStringLexerTests: XCTestCase {
    private final class TokenDelegate: HTMLStringLexerDelegate {
        var tokens: [HTMLStringLexer.Token] = []

        func lexer(_ lexer: HTMLStringLexer, foundToken token: HTMLStringLexer.Token) {
            tokens.append(token)
        }
    }

    private let lexer = HTMLStringLexer()

    private let lexerDelegate = TokenDelegate()

    private var makeLexerDelegate: TokenDelegate {
        let delegate = TokenDelegate()
        lexer.delegate = delegate
        return delegate
    }

    override func setUpWithError() throws {
        lexerDelegate.tokens.removeAll()
        lexer.delegate = lexerDelegate
    }

    func testJustText() throws {
        let html = #"This is a test"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .text(html)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginMarkerInText() throws {
        let html = #"< This is a <test< <"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .text(html)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginTag() throws {
        let html = #"<div><div/>"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .beginTag(name: "div", attributes: [:], isSelfClosing: false),
            .beginTag(name: "div", attributes: [:], isSelfClosing: true),
            .endTag(name: "div"),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginTagVariants() throws {
        let html = #"<div ><div   ><div /><div   />"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .beginTag(name: "div", attributes: [:], isSelfClosing: false),
            .beginTag(name: "div", attributes: [:], isSelfClosing: false),
            .beginTag(name: "div", attributes: [:], isSelfClosing: true),
            .endTag(name: "div"),
            .beginTag(name: "div", attributes: [:], isSelfClosing: true),
            .endTag(name: "div"),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginTagWithAttributes() throws {
        let html = #"<div foo="bar">"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginTagWithMultipleAttributes() throws {
        let html = #"<div foo="bar" custom="asdf" bar='foo'>"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .beginTag(name: "div", attributes: [
                "foo": "bar",
                "custom": "asdf",
                "bar": "foo"
            ], isSelfClosing: false)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeEdgeCases() throws {
        let html = #"<div foo=">" custom="<" apostrophe="she said 'what?'" ampersand='she said "what?"' >"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .beginTag(name: "div", attributes: [
                "foo": ">",
                "custom": "<",
                "apostrophe": "she said 'what?'",
                "ampersand": "she said \"what?\""
            ], isSelfClosing: false)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testEndTag() throws {
        let html = #"</div>"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .endTag(name: "div")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testEndTagVariants() throws {
        let html = #"</div></div ></div   >"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .endTag(name: "div"),
            .endTag(name: "div"),
            .endTag(name: "div"),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testSelfClosedTag() throws {
        let html = #"<div/><div /><div   />"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .beginTag(name: "div", attributes: [:], isSelfClosing: true),
            .endTag(name: "div"),
            .beginTag(name: "div", attributes: [:], isSelfClosing: true),
            .endTag(name: "div"),
            .beginTag(name: "div", attributes: [:], isSelfClosing: true),
            .endTag(name: "div"),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testCommentTag() throws {
        let html = #"<!--foo--><!-- foo --><!----><!--   -->"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .commentTag(text: "foo"),
            .commentTag(text: " foo "),
            .commentTag(text: ""),
            .commentTag(text: "   "),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testDocumentTag() throws {
        let html = #"<!DOCUMENT HTML><!DOCUMENT HTML foo>"#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .documentTag(name: "DOCUMENT", text: "HTML"),
            .documentTag(name: "DOCUMENT", text: "HTML foo"),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testMixedTags() throws {
        let html = #"This is <b>bold</b> and<br> this<br/> is <div style="foo">custom styled</div>."#
        lexer.read(html: html)
        let reference: [HTMLStringLexer.Token] = [
            .text("This is "),
            .beginTag(name: "b", attributes: [:], isSelfClosing: false),
            .text("bold"),
            .endTag(name: "b"),
            .text(" and"),
            .beginTag(name: "br", attributes: [:], isSelfClosing: false),
            .text(" this"),
            .beginTag(name: "br", attributes: [:], isSelfClosing: true),
            .endTag(name: "br"),
            .text(" is "),
            .beginTag(name: "div", attributes: ["style": "foo"], isSelfClosing: false),
            .text("custom styled"),
            .endTag(name: "div"),
            .text("."),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }
}
