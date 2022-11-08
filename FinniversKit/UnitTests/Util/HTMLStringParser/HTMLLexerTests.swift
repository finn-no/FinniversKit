import XCTest
@testable import FinniversKit

final class HTMLLexerTests: XCTestCase {
    private final class TokenCollector: HTMLLexerDelegate {
        var tokens: [HTMLLexer.Token] = []

        func lexer(_ lexer: HTMLLexer, didFindToken token: HTMLLexer.Token) {
            tokens.append(token)
        }
    }

    private func lexer() -> HTMLLexer {
        let lexer = HTMLLexer()
        lexerDelegate.tokens.removeAll()
        lexer.delegate = lexerDelegate
        return lexer
    }

    private var lexerDelegate = TokenCollector()

    func testNoTag() throws {
        let html = "<< > < <"
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .text(html)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testCommentTag() throws {
        let lexer = lexer()
        let html = "<!-- Foo -->"
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .commentTag(" Foo ")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testCommentNoEnd() throws {
        let lexer = lexer()
        let html = "Asdf <!-- Foo"
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .text("Asdf <!-- Foo")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testCommentDoubleEnd() throws {
        let lexer = lexer()
        let html = "<!-- Foo -->-->"
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .commentTag(" Foo "),
            .text("-->")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginTag() throws {
        let lexer = lexer()
        let html = "<b><b >"
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "b", attributes: [:], isSelfClosing: false),
            .startTag(name: "b", attributes: [:], isSelfClosing: false),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginMalformedTag() throws {
        let lexer = lexer()
        let html = "< b><b🎃 >"
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .text("< b><b🎃 >")
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginSelfClosedTag() throws {
        let lexer = lexer()
        let html = "<div/><div />"
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "div", attributes: [:], isSelfClosing: true),
            .startTag(name: "div", attributes: [:], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testBeginSelfClosedMalformedTag() throws {
        let html = "<div/ ><div / >"
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .text(html)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testEndTag() throws {
        let lexer = lexer()
        let html = "</b></b >"
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .endTag(name: "b"),
            .endTag(name: "b"),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testEndMalformedTag() throws {
        let html = "</ b> </b/> </b /> </🎃>"
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .text(html)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeSingle() throws {
        let html = "<div custom><div  custom/><div custom ><div custom />"
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "div", attributes: ["custom": ""], isSelfClosing: false),
            .startTag(name: "div", attributes: ["custom": ""], isSelfClosing: true),
            .startTag(name: "div", attributes: ["custom": ""], isSelfClosing: false),
            .startTag(name: "div", attributes: ["custom": ""], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeSingleEqual() throws {
        let html = "<div custom=><div  custom=/><div custom= ><div custom= />"
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "div", attributes: ["custom": ""], isSelfClosing: false),
            .startTag(name: "div", attributes: ["custom": ""], isSelfClosing: true),
            .startTag(name: "div", attributes: ["custom": ""], isSelfClosing: false),
            .startTag(name: "div", attributes: ["custom": ""], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeAmpersandQuotedValue() throws {
        let html = #"<div foo="bar"><div  foo="bar"/><div foo="bar" ><div foo="bar" />"#
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeApostropheQuotedValue() throws {
        let html = #"<div foo='bar'><div  foo='bar'/><div foo='bar' ><div foo='bar' />"#
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeUnquotedValue() throws {
        let html = #"<div foo=bar><div  foo=bar /><div foo=bar bar=foo >"#
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: false),
            .startTag(name: "div", attributes: ["foo": "bar"], isSelfClosing: true),
            .startTag(name: "div", attributes: ["foo": "bar", "bar": "foo"], isSelfClosing: false),
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testTagAttributeMix() throws {
        let html = #"<div a b=foo c d="foo" e f='foo'>"#
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .startTag(name: "div", attributes: [
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

    func testDoctype() throws {
        let html = #"<!DOCTYPE html><!doctype HTML><!dOcTyPe HtMl>"#
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .doctypeTag(type: "html", legacy: nil),
            .doctypeTag(type: "HTML", legacy: nil),
            .doctypeTag(type: "HtMl", legacy: nil)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }

    func testDoctypeLegacy() throws {
        let html = #"<!DOCTYPE html SYSTEM "about:legacy-compat">"#
        let lexer = lexer()
        lexer.read(html: html)
        let reference: [HTMLLexer.Token] = [
            .doctypeTag(type: "html", legacy: #"SYSTEM "about:legacy-compat""#)
        ]
        XCTAssertEqual(lexerDelegate.tokens, reference)
    }
}
