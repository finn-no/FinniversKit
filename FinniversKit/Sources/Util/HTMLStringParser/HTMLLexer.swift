import Foundation

public protocol HTMLLexerDelegate: AnyObject {
    func lexer(_ lexer: HTMLLexer, didFindToken token: HTMLLexer.Token)
}

/// A lexer to parse a HTML string into tokens representing the order of the various elements.
///
/// Example: The string "A <b>bold</b> move" will output
/// ```
/// [
///     .text("A "),
///     .startTag(name: "b", attributes: [:], isSelfClosing: false),
///     .text("bold"),
///     .endTag(name: "b"),
///     .text(" move")
/// ]
/// ```
public final class HTMLLexer {
    public enum Token: Equatable {
        case startTag(name: String, attributes: [String: String], isSelfClosing: Bool)
        case endTag(name: String)
        case text(String)
        case commentTag(String)
        case doctypeTag(type: String, legacy: String?)
    }

    public weak var delegate: HTMLLexerDelegate?

    private let scanner: Scanner

    public init(html: String) {
        let scanner = Scanner(string: html)
        scanner.charactersToBeSkipped = nil
        self.scanner = scanner
    }

    public func read() {
        var accumulatedText = ""
        var potentialTagIndex = scanner.currentIndex
        while !scanner.isAtEnd {
            if let foundText = scanUpToString("<") {
                accumulatedText.append(foundText)
            }
            if scanner.isAtEnd { break }
            potentialTagIndex = currentIndex
            if let token = scanTag() {
                emitText(&accumulatedText)
                emitToken(token)
            } else {
                // Not a tag, append text scanned while searching
                let foundText = scanner.string[potentialTagIndex..<currentIndex]
                accumulatedText.append(String(foundText))
            }
        }
        emitText(&accumulatedText)
    }

    // MARK: - Emit functions

    private func emitText(_ text: inout String) {
        guard !text.isEmpty else { return }
        emitToken(.text(text))
        text.removeAll()
    }

    private func emitToken(_ token: Token) {
        delegate?.lexer(self, didFindToken: token)
    }

    // MARK: - String and character identification

    private func isAsciiAlphanumeric(_ character: Character) -> Bool {
        return CharacterSet.asciiAlphanumerics.contains(character)
    }

    private func isAsciiWhitespace(_ character: Character) -> Bool {
        return CharacterSet.asciiWhitespace.contains(character)
    }

    private func isEndOfTag(_ character: Character) -> Bool {
        return character == ">" || character == "/"
    }

    // MARK: - Scan helper functions

    private var currentCharacter: Character? {
        return scanner.currentCharacter
    }

    private var currentIndex: String.Index {
        return scanner.currentIndex
    }

    private func nextCharacter(_ offset: Int = 1) -> Character? {
        return scanner.peekCharacter(offset)
    }

    private func peekCharacter(_ offset: Int = 0) -> Character? {
        return scanner.peekCharacter(offset)
    }

    private func peekCharacter(_ character: Character, offset: Int = 0) -> Bool {
        if scanner.isAtEnd { return false }
        var index = scanner.currentIndex
        for _ in 0..<offset {
            index = scanner.string.index(after: index)
            if index == scanner.string.endIndex { return false }
        }
        return character == scanner.string[index]
    }

    private func scanCharacter() -> Character? {
        return scanner.scanCharacter()
    }

    private func scanCharacter(_ character: Character) -> Bool {
        guard scanner.currentCharacter == character else { return false }
        scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        return true
    }

    private func scanString(_ string: String) -> Bool {
        return scanner.scanString(string) != nil
    }

    private func scanUpToString(_ string: String) -> String? {
        return scanner.scanUpToString(string)
    }

    @discardableResult
    private func skipAsciiWhitespace() -> Bool {
        repeat {
            guard
                let currentChar = currentCharacter,
                isAsciiWhitespace(currentChar)
            else { break }
        } while scanCharacter() != nil
        return true
    }

    // MARK: - Scan functions

    private func scanTag() -> Token? {
        guard
            scanCharacter() == "<",
            let nextCharacter = currentCharacter
        else { return nil }
        if nextCharacter == "!" {
            return scanCommentTag() ?? scanDoctypeTag()
        } else if nextCharacter == "/" {
            return scanEndTag()
        }
        return scanBeginTag()
    }

    private func scanCommentTag() -> Token? {
        let endMarker = "-->"
        guard
            scanString("!--"),
            let comment = scanUpToString(endMarker),
            scanString(endMarker)
        else { return nil }
        return .commentTag(comment)
    }

    private func scanDoctypeTag() -> Token? {
        guard
            scanCharacter()?.uppercased() == "!",
            scanCharacter()?.uppercased() == "D",
            scanCharacter()?.uppercased() == "O",
            scanCharacter()?.uppercased() == "C",
            scanCharacter()?.uppercased() == "T",
            scanCharacter()?.uppercased() == "Y",
            scanCharacter()?.uppercased() == "P",
            scanCharacter()?.uppercased() == "E",
            skipAsciiWhitespace()
        else { return nil }
        let typeStartIndex = currentIndex
        guard
            scanCharacter()?.lowercased() == "h",
            scanCharacter()?.lowercased() == "t",
            scanCharacter()?.lowercased() == "m",
            scanCharacter()?.lowercased() == "l"
        else { return nil }
        let type = scanner.string[typeStartIndex..<currentIndex]
        guard
            skipAsciiWhitespace(),
            let nextChar = currentCharacter
        else { return nil }
        if nextChar == ">" {
            _ = scanCharacter()
            return .doctypeTag(type: String(type), legacy: nil)
        }
        guard let legacyText = scanUpToString(">") else { return nil }
        _ = scanCharacter()
        return .doctypeTag(type: String(type), legacy: legacyText)
    }

    private func scanBeginTag() -> Token? {
        // https://html.spec.whatwg.org/multipage/syntax.html#start-tags

        func scanEndOfTag(isSelfClosing: inout Bool) -> Bool {
            var character = scanCharacter()
            if character == "/" {
                isSelfClosing = true
                character = scanCharacter()
            } else {
                isSelfClosing = false
            }
            return character == ">"
        }

        guard
            let name = scanTagName(isBeginTag: true),
            skipAsciiWhitespace(),
            let currentChar = currentCharacter
        else { return nil }
        if isEndOfTag(currentChar) {
            var isSelfClosing = false
            guard scanEndOfTag(isSelfClosing: &isSelfClosing) else { return nil }
            return .startTag(name: name, attributes: [:], isSelfClosing: isSelfClosing)
        }

        var attributes: [String: String] = [:]
        if let foundAttributes = scanTagAttributes() {
            attributes = foundAttributes
        }
        var isSelfClosing = false
        guard scanEndOfTag(isSelfClosing: &isSelfClosing) else { return nil }
        return .startTag(name: name, attributes: attributes, isSelfClosing: isSelfClosing)
    }

    private func scanEndTag() -> Token? {
        // https://html.spec.whatwg.org/multipage/syntax.html#end-tags
        guard
            scanCharacter() == "/",
            let name = scanTagName(isBeginTag: false),
            skipAsciiWhitespace(),
            scanCharacter() == ">"
        else { return nil }
        return .endTag(name: name)
    }

    private func scanTagName(isBeginTag: Bool) -> String? {
        // https://html.spec.whatwg.org/multipage/syntax.html#syntax-tag-name
        let nameStartIndex = scanner.currentIndex
        while let foundChar = scanCharacter() {
            guard
                isAsciiAlphanumeric(foundChar),
                let currentChar = currentCharacter
            else { return nil }
            if isBeginTag {
                if currentChar == ">"
                    || currentChar == "/"
                    || isAsciiWhitespace(currentChar) {
                    break
                }
            } else {
                if currentChar == ">"
                    || isAsciiWhitespace(currentChar) {
                    break
                }
            }
        }
        let name = scanner.string[nameStartIndex..<scanner.currentIndex]
        return name.isEmpty ? nil : String(name)
    }

    private func scanTagAttributes() -> [String: String]? {
        // https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
        var attributes: [String: String] = [:]
        while let nextChar = currentCharacter, !isEndOfTag(nextChar) {
            guard let (name, value) = scanTagAttribute() else {
                skipAsciiWhitespace()
                continue
            }
            attributes[name] = value
            skipAsciiWhitespace()
        }
        return attributes
    }

    private func scanTagAttribute() -> (String, String)? {
        // Attributes have several variants:
        // name
        // name \s* =
        // name \s* = \s* value
        // name \s* = \s* 'value'
        // name \s* = \s* "value"
        guard
            let name = scanTagAttributeName(),
            skipAsciiWhitespace(),
            let nextChar = currentCharacter
        else { return nil }
        if isEndOfTag(nextChar) || nextChar != "=" {
            return (name, "")
        }
        guard
            scanCharacter() == "=",
            skipAsciiWhitespace(),
            let nextChar = currentCharacter
        else { return nil }
        if isEndOfTag(nextChar) {
            return (name, "")
        }
        guard let value = scanTagAttributeValue() else { return nil }
        return (name, value)
    }

    private func scanTagAttributeName() -> String? {
        // https://html.spec.whatwg.org/multipage/syntax.html#syntax-attribute-name
        let nameStartIndex = scanner.currentIndex
        while true {
            guard
                let character = scanCharacter(),
                CharacterSet.htmlAttributeName.contains(character),
                let nextChar = currentCharacter
            else { return nil }
            if nextChar == "=" || isAsciiWhitespace(nextChar) || isEndOfTag(nextChar) {
                break
            }
        }
        let name = scanner.string[nameStartIndex..<scanner.currentIndex]
        return String(name)
    }

    private func scanTagAttributeValue() -> String? {
        guard let nextChar = currentCharacter else { return nil }
        if nextChar == "\"" || nextChar == "'" {
            return scanTagAttributeQuotedValue()
        }
        return scanTagAttributeUnquotedValue()
    }

    private func scanTagAttributeQuotedValue() -> String? {
        guard
            let quote = scanCharacter(),
            quote == "\"" || quote == "'"
        else { return nil }
        guard
            let value = scanner.scanUpToString(String(quote)),
            scanCharacter() == quote
        else { return nil }
        return value
    }

    private func scanTagAttributeUnquotedValue() -> String? {
        let valueStartIndex = scanner.currentIndex
        while true {
            guard let nextChar = currentCharacter else { return nil }
            if !CharacterSet.htmlNonQuotedAttributeValue.contains(nextChar) { break }
            guard scanCharacter() != nil else { return nil }
        }
        let value = scanner.string[valueStartIndex..<scanner.currentIndex]
        return String(value)
    }
}

fileprivate extension Scanner {
    var currentCharacter: Character? {
        if isAtEnd { return nil }
        return string[currentIndex]
    }

    func peekCharacter(_ lookAhead: Int = 1) -> Character? {
        guard !isAtEnd else { return nil }
        var index = currentIndex
        for _ in 0 ..< lookAhead {
            index = string.index(after: index)
            guard index < string.endIndex else { return nil }
        }
        return string[index]
    }
}
