import XCTest
@testable import FinniversKit

final class HTMLLexerTests: XCTestCase {
    private final class TokenCollector: HTMLLexerDelegate {
        var tokens: [HTMLLexer.Token] = []

        func lexer(_ lexer: HTMLLexer, didFindToken token: HTMLLexer.Token) {
            tokens.append(token)
        }
    }

    private func lexer(html: String) -> HTMLLexer {
        let lexer = HTMLLexer(html: html)
        lexerDelegate.tokens.removeAll()
        lexer.delegate = lexerDelegate
        return lexer
    }

    private var lexerDelegate = TokenCollector()

    func testNoTag() throws {
        let html = "<< > < <"
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .text(html)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testCommentTag() throws {
        let lexer = lexer(html: "<!-- Foo -->")
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .commentTag(" Foo ")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testCommentNoEnd() throws {
        let lexer = lexer(html: "Asdf <!-- Foo")
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .text("Asdf <!-- Foo")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testCommentDoubleEnd() throws {
        let lexer = lexer(html: "<!-- Foo -->-->")
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .commentTag(" Foo "),
            .text("-->")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginTag() throws {
        let lexer = lexer(html: "<b><b >")
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .beginTag(name: "b", attributes: [:], isSelfClosing: false),
            .beginTag(name: "b", attributes: [:], isSelfClosing: false),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginMalformedTag() throws {
        let lexer = lexer(html: "< b><b🎃 >")
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .text("< b><b🎃 >")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginSelfClosedTag() throws {
        let lexer = lexer(html: "<div/><div />")
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .beginTag(name: "div", attributes: [:], isSelfClosing: true),
            .beginTag(name: "div", attributes: [:], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginSelfClosedMalformedTag() throws {
        let html = "<div/ ><div / >"
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .text(html)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testEndTag() throws {
        let lexer = lexer(html: "</b></b >")
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .endTag(name: "b"),
            .endTag(name: "b"),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testEndMalformedTag() throws {
        let html = "</ b> </b/> </b /> </🎃>"
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .text(html)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeSingle() throws {
        let html = "<div custom><div  custom/><div custom ><div custom />"
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .beginTag(name: "div", attributes: ["custom": ""], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["custom": ""], isSelfClosing: true),
            .beginTag(name: "div", attributes: ["custom": ""], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["custom": ""], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeSingleEqual() throws {
        let html = "<div custom=><div  custom=/><div custom= ><div custom= />"
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .beginTag(name: "div", attributes: ["custom": ""], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["custom": ""], isSelfClosing: true),
            .beginTag(name: "div", attributes: ["custom": ""], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["custom": ""], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeAmpersandQuotedValue() throws {
        let html = #"<div foo="bar"><div  foo="bar"/><div foo="bar" ><div foo="bar" />"#
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeApostropheQuotedValue() throws {
        let html = #"<div foo='bar'><div  foo='bar'/><div foo='bar' ><div foo='bar' />"#
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeUnquotedValue() throws {
        let html = #"<div foo=bar><div  foo=bar /><div foo=bar bar=foo >"#
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .beginTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
            .beginTag(name: "div", attributes: ["foo": "bar", "bar": "foo"], isSelfClosing: false),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeMix() throws {
        let html = #"<div a b=foo c d="foo" e f='foo'>"#
        let lexer = lexer(html: html)
        lexer.read()
        let reference: [HTMLLexer.Token] = [
            .beginTag(name: "div", attributes: [
                "a": "",
                "b": "foo",
                "c": "",
                "d": "foo",
                "e": "",
                "f": "foo"
            ], isSelfClosing: false),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }
}
