import Foundation

extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        for scalar in character.unicodeScalars {
            if !self.contains(scalar) { return false }
        }
        return true
    }
}

extension CharacterSet {
    static var asciiControlCharacters: CharacterSet = {
        // A control is a C0 control or a code point in the range U+007F DELETE to
        // U+009F APPLICATION PROGRAM COMMAND, inclusive.
        var charSet = CharacterSet()
        let range = Unicode.Scalar(0x7F)...Unicode.Scalar(0x9F)
        charSet.insert(charactersIn: range)
        return charSet
    }()

    static var asciiDigits: CharacterSet = {
        // An ASCII digit is a code point in the range U+0030 (0) to U+0039 (9), inclusive.
        var charSet = CharacterSet()
        let digitRange = Unicode.Scalar(0x30)...Unicode.Scalar(0x39)
        charSet.insert(charactersIn: digitRange)
        return charSet
    }()

    static var asciiUppercaseAlpha: CharacterSet {
        // An ASCII upper alpha is a code point in the range U+0041 (A) to U+005A (Z), inclusive.
        var charSet = CharacterSet()
        let upperAlphaRange = Unicode.Scalar(0x41)...Unicode.Scalar(0x5A)
        charSet.insert(charactersIn: upperAlphaRange)
        return charSet
    }

    static var asciiLowercaseAlpha: CharacterSet {
        // An ASCII lower alpha is a code point in the range U+0061 (a) to U+007A (z), inclusive.
        var charSet = CharacterSet()
        let lowerAlphaRange = Unicode.Scalar(0x61)...Unicode.Scalar(0x7A)
        charSet.insert(charactersIn: lowerAlphaRange)
        return charSet
    }

    static var asciiAlphanumerics: CharacterSet = {
        var charSet = CharacterSet()
        charSet.formUnion(asciiDigits)
        charSet.formUnion(asciiUppercaseAlpha)
        charSet.formUnion(asciiLowercaseAlpha)
        return charSet
    }()

    static var asciiWhitespace: CharacterSet = {
        // ASCII whitespace is U+0009 TAB, U+000A LF, U+000C FF, U+000D CR, or U+0020 SPACE.
        var charSet = CharacterSet()
        charSet.insert(Unicode.Scalar(0x09))
        charSet.insert(Unicode.Scalar(0x0A))
        charSet.insert(Unicode.Scalar(0x0C))
        charSet.insert(Unicode.Scalar(0x0D))
        charSet.insert(Unicode.Scalar(0x20))
        return charSet
    }()

    static var htmlAttributeName: CharacterSet = {
        // Attributes have a name and a value. Attribute names must consist of one or more
        // characters other than controls, U+0020 SPACE, U+0022 ("), U+0027 ('), U+003E (>),
        // U+002F (/), U+003D (=), and noncharacters. In the HTML syntax, attribute names, even
        // those for foreign elements, may be written with any mix of ASCII lower and ASCII
        // upper alphas.
        var charSet = CharacterSet()
        charSet.formUnion(asciiControlCharacters)
        charSet.insert(Unicode.Scalar(0x20))
        charSet.insert(Unicode.Scalar(0x22))
        charSet.insert(Unicode.Scalar(0x27))
        charSet.insert(Unicode.Scalar(0x3E))
        charSet.insert(Unicode.Scalar(0x2F))
        charSet.insert(Unicode.Scalar(0x3D))
        charSet.formUnion(htmlNoncharacter)
        charSet.invert()
        return charSet
    }()

    static var htmlNonQuotedAttributeValue: CharacterSet = {
        // [...] in addition to the requirements given above for attribute values, must not
        // contain any literal ASCII whitespace, any U+0022 QUOTATION MARK characters ("),
        // U+0027 APOSTROPHE characters ('), U+003D EQUALS SIGN characters (=),
        // U+003C LESS-THAN SIGN characters (<), U+003E GREATER-THAN SIGN characters (>),
        // or U+0060 GRAVE ACCENT characters (`), and must not be the empty string.
        var charSet = CharacterSet()
        charSet.formUnion(asciiWhitespace)
        charSet.insert(Unicode.Scalar(0x22))
        charSet.insert(Unicode.Scalar(0x27))
        charSet.insert(Unicode.Scalar(0x3C))
        charSet.insert(Unicode.Scalar(0x3D))
        charSet.insert(Unicode.Scalar(0x3E))
        charSet.insert(Unicode.Scalar(0x60))
        charSet.invert()
        return charSet
    }()

    static var htmlNoncharacter: CharacterSet = {
        // A noncharacter is a code point that is in the range U+FDD0 to U+FDEF, inclusive,
        // or U+FFFE, U+FFFF, U+1FFFE, U+1FFFF, U+2FFFE, U+2FFFF, U+3FFFE, U+3FFFF, U+4FFFE,
        // U+4FFFF, U+5FFFE, U+5FFFF, U+6FFFE, U+6FFFF, U+7FFFE, U+7FFFF, U+8FFFE, U+8FFFF,
        // U+9FFFE, U+9FFFF, U+AFFFE, U+AFFFF, U+BFFFE, U+BFFFF, U+CFFFE, U+CFFFF, U+DFFFE,
        // U+DFFFF, U+EFFFE, U+EFFFF, U+FFFFE, U+FFFFF, U+10FFFE, or U+10FFFF.
        var charSet = CharacterSet()
        if let rangeStart = Unicode.Scalar(0xFDD0), let rangeStop = Unicode.Scalar(0xFDEF) {
            charSet.insert(charactersIn: rangeStart...rangeStop)
        }
        [
            0xFFFE,
            0xFFFF,
            0x1FFFE,
            0x1FFFF,
            0x2FFFE,
            0x2FFFF,
            0x3FFFE,
            0x3FFFF,
            0x4FFFE,
            0x4FFFF,
            0x5FFFE,
            0x5FFFF,
            0x6FFFE,
            0x6FFFF,
            0x7FFFE,
            0x7FFFF,
            0x8FFFE,
            0x8FFFF,
            0x9FFFE,
            0x9FFFF,
            0xAFFFE,
            0xAFFFF,
            0xBFFFE,
            0xBFFFF,
            0xCFFFE,
            0xCFFFF,
            0xDFFFE,
            0xDFFFF,
            0xEFFFE,
            0xEFFFF,
            0xFFFFE,
            0xFFFFF,
            0x10FFFE,
            0x10FFFF,
        ].compactMap {
            Unicode.Scalar($0)
        }.forEach {
            charSet.insert($0)
        }
        return charSet
    }()
}
