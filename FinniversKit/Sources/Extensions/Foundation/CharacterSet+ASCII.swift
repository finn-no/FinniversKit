import Foundation

extension CharacterSet {
    /// An ASCII control character is a `C0` control or a code point in the range `U+007F DELETE`
    /// to `U+009F APPLICATION PROGRAM COMMAND`, inclusive.
    static let asciiControlCharacters: CharacterSet = {
        var charSet = CharacterSet()
        let range = Unicode.Scalar(0x7F)...Unicode.Scalar(0x9F)
        charSet.insert(charactersIn: range)
        return charSet
    }()

    /// An ASCII digit is a code point in the range `U+0030 (0)` to `U+0039 (9)`, inclusive.
    static let asciiDigits: CharacterSet = {
        var charSet = CharacterSet()
        let digitRange = Unicode.Scalar(0x30)...Unicode.Scalar(0x39) // 0...9
        charSet.insert(charactersIn: digitRange)
        return charSet
    }()

    /// An ASCII upper alpha is a code point in the range `U+0041 (A)` to `U+005A (Z)`, inclusive.
    static let asciiUppercaseAlpha: CharacterSet = {
        var charSet = CharacterSet()
        let upperAlphaRange = Unicode.Scalar(0x41)...Unicode.Scalar(0x5A) // A...Z
        charSet.insert(charactersIn: upperAlphaRange)
        return charSet
    }()

    /// An ASCII lower alpha is a code point in the range `U+0061 (a)` to `U+007A (z)`, inclusive.
    static let asciiLowercaseAlpha: CharacterSet = {
        var charSet = CharacterSet()
        let lowerAlphaRange = Unicode.Scalar(0x61)...Unicode.Scalar(0x7A) // a...z
        charSet.insert(charactersIn: lowerAlphaRange)
        return charSet
    }()

    /// The ASCII alphanumerics set is the combined set of digits, lowercase letters and
    /// uppercase letters.
    static let asciiAlphanumerics: CharacterSet = {
        var charSet = CharacterSet()
        charSet.formUnion(asciiDigits)
        charSet.formUnion(asciiUppercaseAlpha)
        charSet.formUnion(asciiLowercaseAlpha)
        return charSet
    }()

    /// ASCII whitespace is `U+0009 TAB`, `U+000A LF`, `U+000C FF`, `U+000D CR`, or `U+0020 SPACE`.
    static let asciiWhitespace: CharacterSet = {
        var charSet = CharacterSet()
        charSet.insert(Unicode.Scalar(0x09)) // TAB
        charSet.insert(Unicode.Scalar(0x0A)) // LF
        charSet.insert(Unicode.Scalar(0x0C)) // FF
        charSet.insert(Unicode.Scalar(0x0D)) // CR
        charSet.insert(Unicode.Scalar(0x20)) // SPACE
        return charSet
    }()
}
