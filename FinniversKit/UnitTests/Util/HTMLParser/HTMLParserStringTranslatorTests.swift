import XCTest
import FinniversKit

final class HTMLParserStringTranslatorTests: XCTestCase {
    let parser = HTMLParser()
    var translator = HTMLParserStringTranslator()

    func testStringTranslator() throws {
        let boldText = "<html>This is a <b>bold</b> move</html>"
        translator.omitHTMLDocumentElements = false
        translator.stripAllHTMLElements = false
        let parsedText = try parser.parse(html: boldText, translator: translator)
        XCTAssertEqual(boldText, parsedText)
    }

    func testStringTranslatorOmitHTMLElements() throws {
        let boldText = "This is a <b>bold</b> move"
        translator.omitHTMLDocumentElements = true
        translator.stripAllHTMLElements = false
        let parsedText = try parser.parse(html: boldText, translator: translator)
        XCTAssertEqual(boldText, parsedText)
    }

    func testStringTranslatorStripHTML() throws {
        let boldText = "This is a <b>bold</b> move"
        let noHTMLText = "This is a bold move"
        translator.stripAllHTMLElements = true
        let parsedText = try parser.parse(html: boldText, translator: translator)
        XCTAssertEqual(noHTMLText, parsedText)
    }
}
