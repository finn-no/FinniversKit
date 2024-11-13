import XCTest
@testable import FinniversKit

final class StringExtensionsTests: XCTestCase {
    func testWithoutEmojiExtension() throws {
        let stringFI = "Push-notifikaatiosi ovat pois päältä, lisää myyntimahdollisuuksiasi ottamalla push-notifikaatiot käyttöön."
        let resultFI = stringFI.withoutEmoji()
        XCTAssertEqual(resultFI, stringFI)

        let stringNO = "Treg respons er en dealbreaker – skru på varslinger så du lettere får solgt varene dine 💰"
        let resultNO = stringNO.withoutEmoji()
        XCTAssertEqual(resultNO, "Treg respons er en dealbreaker – skru på varslinger så du lettere får solgt varene dine ")

        let stringEN = "Your push notifications are turned off"
        let resultEN = stringEN.withoutEmoji()
        XCTAssertEqual(resultEN, stringEN)

        let string1 = "Hello, 👋"
        let result1 = string1.withoutEmoji()
        XCTAssertEqual(result1, "Hello, ")

        let string2 = "👦 Hello, 👋"
        let result2 = string2.withoutEmoji()
        XCTAssertEqual(result2, " Hello, ")
    }
}
