import Foundation

extension CharacterSet {
    /// HTML attributes have a name and a value. Attribute names must consist of one or more
    /// characters other than controls, `U+0020 SPACE`, `U+0022 (")`, `U+0027 (')`, `U+003E (>)`,
    /// `U+002F (/)`, `U+003D (=)`, and noncharacters. In the HTML syntax, attribute names, even
    /// those for foreign elements, may be written with any mix of ASCII lower and ASCII
    /// upper alphas.
    static let htmlAttributeName: CharacterSet = {
        var charSet = CharacterSet()
        charSet.formUnion(asciiControlCharacters)
        charSet.insert(Unicode.Scalar(0x20)) // SPACE
        charSet.insert(Unicode.Scalar(0x22)) // "
        charSet.insert(Unicode.Scalar(0x27)) // '
        charSet.insert(Unicode.Scalar(0x3E)) // >
        charSet.insert(Unicode.Scalar(0x2F)) // /
        charSet.insert(Unicode.Scalar(0x3D)) // =
        charSet.formUnion(htmlNoncharacter)
        charSet.invert()
        return charSet
    }()

    /// Non-quoted HTML attribute values have the same requirements as quoted attribute
    /// values, and must additionally not contain any literal ASCII whitespace, any
    /// `U+0022 QUOTATION MARK` characters ("), `U+0027 APOSTROPHE` characters ('),
    /// `U+003D EQUALS SIGN` characters (=), `U+003C LESS-THAN SIGN` characters (<),
    /// `U+003E GREATER-THAN SIGN` characters (>), or `U+0060 GRAVE ACCENT` characters (`),
    /// and must not be the empty string.
    static let htmlNonQuotedAttributeValue: CharacterSet = {
        var charSet = CharacterSet()
        charSet.formUnion(asciiWhitespace)
        charSet.insert(Unicode.Scalar(0x22)) // "
        charSet.insert(Unicode.Scalar(0x27)) // '
        charSet.insert(Unicode.Scalar(0x3C)) // <
        charSet.insert(Unicode.Scalar(0x3D)) // =
        charSet.insert(Unicode.Scalar(0x3E)) // >
        charSet.insert(Unicode.Scalar(0x60)) // `
        charSet.invert()
        return charSet
    }()

    /// A noncharacter is a code point that is in the range U+FDD0 to U+FDEF, inclusive,
    /// or U+FFFE, U+FFFF, U+1FFFE, U+1FFFF, U+2FFFE, U+2FFFF, U+3FFFE, U+3FFFF, U+4FFFE,
    /// U+4FFFF, U+5FFFE, U+5FFFF, U+6FFFE, U+6FFFF, U+7FFFE, U+7FFFF, U+8FFFE, U+8FFFF,
    /// U+9FFFE, U+9FFFF, U+AFFFE, U+AFFFF, U+BFFFE, U+BFFFF, U+CFFFE, U+CFFFF, U+DFFFE,
    /// U+DFFFF, U+EFFFE, U+EFFFF, U+FFFFE, U+FFFFF, U+10FFFE, or U+10FFFF.
    static let htmlNoncharacter: CharacterSet = {
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
