//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import AudioToolbox
@testable import FinniversKit
import XCTest

final class InstrumentTests: XCTestCase {
    func testRawValue() {
        XCTAssertEqual(Instrument.kick.rawValue, "Kick")
        XCTAssertEqual(Instrument.snare.rawValue, "Snare")
        XCTAssertEqual(Instrument.hats.rawValue, "Hi-Hats")
        XCTAssertEqual(Instrument.cat.rawValue, "PuseFINN")
    }

    func testColor() {
        XCTAssertEqual(Instrument.kick.color, .pea)
        XCTAssertEqual(Instrument.snare.color, UIColor(red: 235 / 255.0, green: 201 / 255.0, blue: 62 / 255.0, alpha: 1.0))
        XCTAssertEqual(Instrument.hats.color, .watermelon)
        XCTAssertEqual(Instrument.cat.color, .secondaryBlue)
    }

    func testSound() {
        XCTAssertNotNil(Instrument.kick.sound)
        XCTAssertNotNil(Instrument.snare.sound)
        XCTAssertNotNil(Instrument.hats.sound)
        XCTAssertNotNil(Instrument.cat.sound)
    }

    func testHaptics() {
        XCTAssertEqual(Instrument.kick.haptics, SystemSoundID(1520))
        XCTAssertEqual(Instrument.snare.haptics, SystemSoundID(1519))
        XCTAssertNil(Instrument.hats.haptics)
        XCTAssertNil(Instrument.cat.haptics)
    }
}
