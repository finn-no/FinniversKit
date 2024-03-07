import XCTest
@testable import FinniversKit

final class CharacterReaderTests: XCTestCase {
    func testConsume() throws {
        let reference = "abc"
        var reader = CharacterReader(input: reference)
        XCTAssertEqual(reference, String(reader.input[reader.readIndex..<reader.input.endIndex]))
        XCTAssertEqual(reader.consume(), "a")
        XCTAssertEqual("bc", String(reader.input[reader.readIndex..<reader.input.endIndex]))
    }

    func testConsumeCount() throws {
        let reference = "abc"
        var reader = CharacterReader(input: reference)
        XCTAssertEqual(reader.peek(), "a")
        reader.consume(count: 2)
        XCTAssertEqual(reader.peek(), "c")
    }

    func testConsumeUpTo() throws {
        let reference = "abc"
        var reader = CharacterReader(input: reference)
        XCTAssertEqual(reference, String(reader.input[reader.readIndex..<reader.input.endIndex]))
        XCTAssertEqual(reader.consume(upTo: "c"), "ab")
        XCTAssertEqual("c", String(reader.input[reader.readIndex..<reader.input.endIndex]))
    }

    func testConsumeWhile() throws {
        let reference = "abc"
        var reader = CharacterReader(input: reference)
        XCTAssertEqual(reference, String(reader.input[reader.readIndex..<reader.input.endIndex]))
        XCTAssertEqual(reader.consume(while: { $0 != "c" }), "ab")
        XCTAssertEqual("c", String(reader.input[reader.readIndex..<reader.input.endIndex]))
    }

    func testPeek() throws {
        let reference = "abc"
        let reader = CharacterReader(input: reference)
        XCTAssertEqual(reference, String(reader.input[reader.readIndex..<reader.input.endIndex]))
        XCTAssertEqual(reader.peek(), "a")
        XCTAssertEqual(reference, String(reader.input[reader.readIndex..<reader.input.endIndex]))
    }

    func testSetReadIndex() throws {
        let reference = "abc"
        var reader = CharacterReader(input: reference)
        XCTAssertEqual(reader.peek(), "a")
        reader.setReadIndex(reader.input.index(after: reader.readIndex))
        XCTAssertEqual(reader.peek(), "b")
    }
}
