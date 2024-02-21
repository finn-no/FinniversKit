import XCTest
@testable import FinniversKit

// swiftlint:disable:next type_name
final class UIColor_FinniversKitTests: XCTestCase {
    func testHexStringGrayscaleColorSpace() throws {
        let black = UIColor(white: 0.0, alpha: 1.0)
        XCTAssertEqual(black.hexString, "#000000")

        let gray = UIColor(white: 0.5, alpha: 1.0)
        XCTAssertEqual(gray.hexString, "#7f7f7f")

        let white = UIColor(white: 1.0, alpha: 1.0)
        XCTAssertEqual(white.hexString, "#ffffff")
    }

    func testHexStringExtendedRGBColorSpace() throws {
        let redExtended = UIColor(red: 2.0, green: 0.0, blue: 0.0, alpha: 1.0)
        XCTAssertEqual(redExtended.hexString, "#ff0000")

        let greenExtended = UIColor(red: 0.0, green: 2.0, blue: 0.0, alpha: 1.0)
        XCTAssertEqual(greenExtended.hexString, "#00ff00")

        let blueExtended = UIColor(red: 0.0, green: 0.0, blue: 2.0, alpha: 1.0)
        XCTAssertEqual(blueExtended.hexString, "#0000ff")
    }
}

final class FinniversKitPlaceholderImageTest: XCTestCase {
    func testPlaceholderImage() {
        let redExtended = UIImage(named: .noImage)
        XCTAssertEqual(redExtended, PlaceholderImage.noImage)
    }
}
