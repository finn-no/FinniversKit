import XCTest
import FinniversKit

final class HTMLStringParserTextTranslatorTests: XCTestCase {
    var translator = HTMLStringParserTextTranslator()

    func testStripHTML() throws {
        let boldText = "<html>This is a<br><b>bold</b> move<!-- Is it? --></html>"
        let noHTMLText = "This is a\nbold move"
        let parsedText = try HTMLStringParser.parse(html: boldText, translator: translator)
        XCTAssertEqual(noHTMLText, parsedText)
    }
}
