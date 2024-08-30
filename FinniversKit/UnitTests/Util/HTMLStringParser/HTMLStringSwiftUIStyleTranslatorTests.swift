import XCTest
import FinniversKit

final class HTMLStringSwiftUIStyleTranslatorTests: XCTestCase {
    var translator = HTMLStringSwiftUIStyleTranslator(defaultStyle: .init(font: .body), styleMapper: nil)

    func testBold() throws {
        let boldText = "This is a <b>bold</b> move"
        let styleElements = try HTMLStringParser.parse(html: boldText, translator: translator)
        let reference: [HTMLStringSwiftUIStyleTranslator.StyledText] = [
            .init(text: "This is a ", style: .init(font: .body)),
            .init(text: "bold", style: .init(font: .body, fontWeight: .bold)),
            .init(text: " move", style: .init(font: .body))
        ]
        XCTAssertEqual(styleElements, reference)
    }

    func testMix() throws {
        let boldText = "This <b>bold <i>italic</i></b> thing"
        let styleElements = try HTMLStringParser.parse(html: boldText, translator: translator)
        let reference: [HTMLStringSwiftUIStyleTranslator.StyledText] = [
            .init(text: "This ", style: .init(font: .body)),
            .init(text: "bold ", style: .init(font: .body, fontWeight: .bold)),
            .init(text: "italic", style: .init(font: .body, fontWeight: .bold, italic: true)),
            .init(text: " thing", style: .init(font: .body))
        ]
        XCTAssertEqual(styleElements, reference)
    }

    func testSingleLink() throws {
        let urlString = "https://example.com"
        guard let url = URL(string: urlString) else {
            XCTFail("Foundation has forgotten how to create URLs apparently")
            return
        }

        let linkText = "Here we have <a href=\"\(urlString)\">a link</a>"
        let styleElements = try HTMLStringParser.parse(html: linkText, translator: translator)
        let reference: [HTMLStringSwiftUIStyleTranslator.StyledText] = [
            .init(text: "Here we have ", style: .init(font: .body)),
            .init(text: "a link", style: .init(font: .body, underline: true), attributes: [.url(value: url)]),
        ]
        XCTAssertEqual(styleElements, reference)
    }

    func testMultipleLinks() throws {
        let firstURLString = "https://example.com"
        guard let firstURL = URL(string: firstURLString) else {
            XCTFail("Foundation has forgotten how to create URLs apparently")
            return
        }

        let secondURLString = "https://another-example.com"
        guard let secondURL = URL(string: secondURLString) else {
            XCTFail("Foundation has forgotten how to create URLs apparently")
            return
        }

        let linkText = "Here we have <a href=\"\(firstURLString)\">a link</a> and here is <a href=\"\(secondURLString)\">another one</a>"
        let styleElements = try HTMLStringParser.parse(html: linkText, translator: translator)
        let reference: [HTMLStringSwiftUIStyleTranslator.StyledText] = [
            .init(text: "Here we have ", style: .init(font: .body)),
            .init(text: "a link", style: .init(font: .body, underline: true), attributes: [.url(value: firstURL)]),
            .init(text: " and here is ", style: .init(font: .body)),
            .init(text: "another one", style: .init(font: .body, underline: true), attributes: [.url(value: secondURL)]),
        ]
        XCTAssertEqual(styleElements, reference)
    }
}
