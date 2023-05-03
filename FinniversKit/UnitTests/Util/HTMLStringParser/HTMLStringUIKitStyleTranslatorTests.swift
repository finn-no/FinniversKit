import XCTest
import FinniversKit

final class HTMLStringUIKitStyleTranslatorTests: XCTestCase {
    let parser = HTMLStringParser()
    var translator = HTMLStringUIKitStyleTranslator(defaultStyle: .init(font: .body), styleMapper: nil)

    func testBold() throws {
        let boldText = "This is a <b>bold</b> move"
        let attributedString = try parser.parse(html: boldText, translator: translator)

        let requiredAttributes = [
            NSAttributedString.FontAttributes(
                fontDescriptor: UIFont.body.fontDescriptor,
                range: NSRange(location: 0, length: 10)
            ),
            NSAttributedString.FontAttributes(
                fontDescriptor: UIFont.body.fontDescriptor.withSymbolicTraits(.traitBold) ?? UIFont.body.fontDescriptor,
                range: NSRange(location: 10, length: 4)
            ),
            NSAttributedString.FontAttributes(
                fontDescriptor: UIFont.body.fontDescriptor,
                range: NSRange(location: 14, length: 5)
            )
        ]

        XCTAssertTrue(attributedString.isMatchingFontAttributes(in: requiredAttributes))
    }

    func testMix() throws {
        let boldText = "This <b>bold <i>italic</i></b> thing"
        let attributedString = try parser.parse(html: boldText, translator: translator)
        let requiredAttributes = [
            NSAttributedString.FontAttributes(
                fontDescriptor: UIFont.body.fontDescriptor,
                range: NSRange(location: 0, length: 5)
            ),
            NSAttributedString.FontAttributes(
                fontDescriptor: UIFont.body.fontDescriptor.withSymbolicTraits(.traitBold) ?? UIFont.body.fontDescriptor,
                range: NSRange(location: 5, length: 11)
            ),
            NSAttributedString.FontAttributes(
                fontDescriptor: UIFont.body.fontDescriptor,
                range: NSRange(location: 16, length: 6)
            )
        ]

        XCTAssertTrue(attributedString.isMatchingFontAttributes(in: requiredAttributes))
    }
}

extension NSAttributedString {
    struct FontAttributes {
        let fontDescriptor: UIFontDescriptor
        let range: NSRange
    }

    func isMatchingFontAttributes(in requiredAttributes: [FontAttributes]) -> Bool {
        var requiredAttributes = requiredAttributes
        enumerateAttribute(.font, in: NSRange(location: 0, length: string.count)) { font, range, _ in
            guard let uiFont = font as? UIFont else {
                return
            }

            if let firsAttribute = requiredAttributes.first,
               uiFont.fontDescriptor.postscriptName == firsAttribute.fontDescriptor.postscriptName,
               uiFont.fontDescriptor.symbolicTraits == firsAttribute.fontDescriptor.symbolicTraits,
               range == firsAttribute.range {
                requiredAttributes.removeFirst()
            }
        }
        return requiredAttributes.isEmpty
    }
}
