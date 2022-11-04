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
        if scanner.isAtEnd { return nil }
        return scanner.string[scanner.currentIndex]
    }

    private var currentIndex: String.Index {
        return scanner.currentIndex
    }

    private func peekCharacter(offset: Int = 0) -> Character? {
        if scanner.isAtEnd { return nil }
        var index = scanner.currentIndex
        for _ in 0..<offset {
            index = scanner.string.index(after: index)
            if index == scanner.string.endIndex { return nil }
        }
        return scanner.string[index]
    }

    private func peekCharacter(_ character: Character, offset: Int = 0) -> Bool {
        guard let foundCharacter = peekCharacter(offset: offset) else { return false }
        return character == foundCharacter
    }

    private func scanCharacter() -> Character? {
        return scanner.scanCharacter()
    }

    private func scanCharacter(_ character: Character) -> Bool {
        guard let foundCharacter = scanner.scanCharacter() else { return false }
        return character == foundCharacter
    }

    private func scanCaseInsensitiveCharacter(_ character: Character) -> Bool {
        guard let foundCharacter = scanner.scanCharacter() else { return false }
        return character.lowercased() == foundCharacter.lowercased()
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
            scanCharacter("<"),
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
            scanCharacter("!"),
            scanCaseInsensitiveCharacter("D"),
            scanCaseInsensitiveCharacter("O"),
            scanCaseInsensitiveCharacter("C"),
            scanCaseInsensitiveCharacter("T"),
            scanCaseInsensitiveCharacter("Y"),
            scanCaseInsensitiveCharacter("P"),
            scanCaseInsensitiveCharacter("E"),
            skipAsciiWhitespace()
        else { return nil }
        let typeStartIndex = currentIndex
        guard
            scanCaseInsensitiveCharacter("h"),
            scanCaseInsensitiveCharacter("t"),
            scanCaseInsensitiveCharacter("m"),
            scanCaseInsensitiveCharacter("l")
        else { return nil }
        let type = scanner.string[typeStartIndex..<currentIndex]
        guard
            skipAsciiWhitespace(),
            let nextChar = peekCharacter()
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
            scanCharacter("/"),
            let name = scanTagName(isBeginTag: false),
            skipAsciiWhitespace(),
            scanCharacter(">")
        else { return nil }
        return .endTag(name: name)
    }

    private func scanTagName(isBeginTag: Bool) -> String? {
        // https://html.spec.whatwg.org/multipage/syntax.html#syntax-tag-name
        let nameStartIndex = scanner.currentIndex
        while let foundChar = scanCharacter() {
            guard
                isAsciiAlphanumeric(foundChar),
                let nextChar = peekCharacter()
            else { return nil }
            if isBeginTag {
                if nextChar == ">"
                    || nextChar == "/"
                    || isAsciiWhitespace(nextChar) {
                    break
                }
            } else {
                if nextChar == ">"
                    || isAsciiWhitespace(nextChar) {
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
        while let nextChar = peekCharacter(), !isEndOfTag(nextChar) {
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
            let nextChar = peekCharacter()
        else { return nil }
        if isEndOfTag(nextChar) || nextChar != "=" {
            return (name, "")
        }
        guard
            scanCharacter("="),
            skipAsciiWhitespace(),
            let nextChar = peekCharacter()
        else { return nil }
        if isEndOfTag(nextChar) {
            return (name, "")
        }
        guard let value = scanTagAttributeValue() else { return nil }
        return (name, value)
    }

    private func scanTagAttributeName() -> String? {
        // https://html.spec.whatwg.org/multipage/syntax.html#syntax-attribute-name
        let nameStartIndex = currentIndex
        while true {
            guard
                let character = scanCharacter(),
                CharacterSet.htmlAttributeName.contains(character),
                let nextChar = peekCharacter()
            else { return nil }
            if nextChar == "=" || isAsciiWhitespace(nextChar) || isEndOfTag(nextChar) {
                break
            }
        }
        let name = scanner.string[nameStartIndex..<scanner.currentIndex]
        return String(name)
    }

    private func scanTagAttributeValue() -> String? {
        guard let nextChar = peekCharacter() else { return nil }
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
            scanCharacter(quote)
        else { return nil }
        return value
    }

    private func scanTagAttributeUnquotedValue() -> String? {
        let valueStartIndex = currentIndex
        while true {
            guard let nextChar = peekCharacter() else { return nil }
            if !CharacterSet.htmlNonQuotedAttributeValue.contains(nextChar) { break }
            guard scanCharacter() != nil else { return nil }
        }
        let value = scanner.string[valueStartIndex..<scanner.currentIndex]
        return String(value)
    }
}
