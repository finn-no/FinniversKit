import XCTest
import FinniversKit

final class HTMLStringSwiftUIStyleTranslatorTests: XCTestCase {
    let parser = HTMLStringParser()
    var translator = HTMLStringSwiftUIStyleTranslator(defaultStyle: .init(font: .body), styleMapper: nil)

    func testBold() throws {
        let boldText = "This is a <b>bold</b> move"
        let styleElements = try parser.parse(html: boldText, translator: translator)
        let reference: [HTMLStringSwiftUIStyleTranslator.StyledText] = [
            .init(text: "This is a ", style: .init(font: .body)),
            .init(text: "bold", style: .init(font: .body, fontWeight: .bold)),
            .init(text: " move", style: .init(font: .body))
        ]
        XCTAssertEqual(styleElements, reference)
    }

    func testMix() throws {
        let boldText = "This <b>bold <i>italic</i></b> thing"
        let styleElements = try parser.parse(html: boldText, translator: translator)
        let reference: [HTMLStringSwiftUIStyleTranslator.StyledText] = [
            .init(text: "This ", style: .init(font: .body)),
            .init(text: "bold ", style: .init(font: .body, fontWeight: .bold)),
            .init(text: "italic", style: .init(font: .body, fontWeight: .bold, italic: true)),
            .init(text: " thing", style: .init(font: .body))
        ]
        XCTAssertEqual(styleElements, reference)
    }
}
