import XCTest
import FinniversKit

final class HTMLStringParserHTMLTranslatorTests: XCTestCase {
    var translator = HTMLStringParserHTMLTranslator()

    func testPreserveHTML() throws {
        let boldText = "<html>This is a<br><b>bold</b> move<!-- Is it? --></html>"
        let parsedText = try HTMLStringParser.parse(html: boldText, translator: translator)
        XCTAssertEqual(boldText, parsedText)
    }
}
