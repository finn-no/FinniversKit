import XCTest
@testable import FinniversKit

final class HTMLLexerTests: XCTestCase {
    func testByteOrderMark() throws {
        let html = "\u{FEFF}asdf"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .byteOrderMark,
            .text("asdf")
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testNoTag() throws {
        let html = "<< > < <"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .text(html)
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testCommentTag() throws {
        let html = "<!-- Foo -->"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .comment(" Foo ")
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testCommentNoEnd() throws {
        let html = "Asdf <!-- Foo"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .text("Asdf <!-- Foo")
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testCommentDoubleEnd() throws {
        let html = "<!-- Foo -->-->"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .comment(" Foo "),
            .text("-->")
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testBeginTag() throws {
        let html = "<b><b >"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "b", attributes: [], isSelfClosing: false),
            .tagStart(name: "b", attributes: [], isSelfClosing: false),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testBeginMalformedTag() throws {
        let html = "< b><b🎃 >"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .text("< b><b🎃 >")
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testBeginSelfClosedTag() throws {
        let html = "<div/><div />"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [], isSelfClosing: true),
            .tagStart(name: "div", attributes: [], isSelfClosing: true),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testBeginSelfClosedMalformedTag() throws {
        let html = "<div/ ><div / >"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .text(html)
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testEndTag() throws {
        let html = "</b></b >"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagEnd(name: "b"),
            .tagEnd(name: "b"),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testEndMalformedTag() throws {
        let html = "</ b> </b/> </b /> </🎃>"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .text(html)
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testTagAttributeSingle() throws {
        let html = "<div custom><div  custom/><div custom ><div custom />"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [.init(name: "custom", value: nil)], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "custom", value: nil)], isSelfClosing: true),
            .tagStart(name: "div", attributes: [.init(name: "custom", value: nil)], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "custom", value: nil)], isSelfClosing: true),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testTagAttributeSingleEqual() throws {
        let html = "<div custom=><div  custom=/><div custom= ><div custom= />"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [.init(name: "custom", value: nil)], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "custom", value: nil)], isSelfClosing: true),
            .tagStart(name: "div", attributes: [.init(name: "custom", value: nil)], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "custom", value: nil)], isSelfClosing: true),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testTagAttributeAmpersandQuotedValue() throws {
        let html = #"<div foo="bar"><div  foo="bar"/><div foo="bar" ><div foo="bar" />"#
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: true),
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: true),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testTagAttributeApostropheQuotedValue() throws {
        let html = #"<div foo='bar'><div  foo='bar'/><div foo='bar' ><div foo='bar' />"#
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: true),
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: true),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testTagAttributeUnquotedValue() throws {
        let html = #"<div foo=bar><div  foo=bar /><div foo=bar bar=foo >"#
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: false),
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar")], isSelfClosing: true),
            .tagStart(name: "div", attributes: [.init(name: "foo", value: "bar"), .init(name: "bar", value: "foo")], isSelfClosing: false),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testTagAttributeMix() throws {
        let html = #"<div a b=foo c d="foo" e f='foo'>"#
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [
                .init(name: "a", value: nil),
                .init(name: "b", value: "foo"),
                .init(name: "c", value: nil),
                .init(name: "d", value: "foo"),
                .init(name: "e", value: nil),
                .init(name: "f", value: "foo")
            ], isSelfClosing: false),
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testDoctype() throws {
        let html = #"<!DOCTYPE html><!doctype HTML><!dOcTyPe HtMl>"#
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .doctype(name: "DOCTYPE", type: "html", legacy: nil),
            .doctype(name: "doctype", type: "HTML", legacy: nil),
            .doctype(name: "dOcTyPe", type: "HtMl", legacy: nil)
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testDoctypeLegacy() throws {
        let html = #"<!DOCTYPE html SYSTEM "about:legacy-compat">"#
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .doctype(name: "DOCTYPE", type: "html", legacy: #"SYSTEM "about:legacy-compat""#)
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testNestedTags() throws {
        let html = "<div><p>Foo, <span>Bar</span>!</p></div>"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "div", attributes: [], isSelfClosing: false),
            .tagStart(name: "p", attributes: [], isSelfClosing: false),
            .text("Foo, "),
            .tagStart(name: "span", attributes: [], isSelfClosing: false),
            .text("Bar"),
            .tagEnd(name: "span"),
            .text("!"),
            .tagEnd(name: "p"),
            .tagEnd(name: "div")
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testTagsWithMultipleAttributes() throws {
        let html = "<img src='image.png' alt=\"An image\" width=100 height=200>"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "img", attributes: [
                .init(name: "src", value: "image.png"),
                .init(name: "alt", value: "An image"),
                .init(name: "width", value: "100"),
                .init(name: "height", value: "200")
            ], isSelfClosing: false)
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testSpecialCharactersInText() throws {
        let html = "Hello &amp; Welcome to <b>Foo&lt;Bar&gt;</b>"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .text("Hello &amp; Welcome to "),
            .tagStart(name: "b", attributes: [], isSelfClosing: false),
            .text("Foo&lt;Bar&gt;"),
            .tagEnd(name: "b")
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testScriptTagsWithContent() throws {
        // Special tags like script and style are not fully supported yet.
        // If they contain text with tags the tags will be parsed instead of
        // treated as text.
        let html = "<script>if (a < b) { console.log(\"a is less than b\"); }</script>"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "script", attributes: [], isSelfClosing: false),
            .text("if (a < b) { console.log(\"a is less than b\"); }"),
            .tagEnd(name: "script")
        ]
        XCTAssertEqual(tokens, reference)
    }

    func testStyleTagsWithCSS() throws {
        // Special tags like script and style are not fully supported yet.
        // If they contain text with tags the tags will be parsed instead of
        // treated as text.
        let html = "<style>body { background-color: #fff; }</style>"
        let tokens = HTMLLexer(html: html).map { $0 }
        let reference: [HTMLToken] = [
            .tagStart(name: "style", attributes: [], isSelfClosing: false),
            .text("body { background-color: #fff; }"),
            .tagEnd(name: "style")
        ]
        XCTAssertEqual(tokens, reference)
    }
}
