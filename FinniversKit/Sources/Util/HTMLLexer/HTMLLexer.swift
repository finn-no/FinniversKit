import Foundation

public enum HTMLToken: Equatable {
    case byteOrderMark
    case comment(String)
    case doctype(name: String, type: String, legacy: String?)
    case tagStart(name: String, attributes: [TagAttribute], isSelfClosing: Bool)
    case tagEnd(name: String)
    case text(String)
}

extension HTMLToken {
    public struct TagAttribute: Equatable {
        public let name: String
        public let value: String?

        public init(name: String, value: String?) {
            self.name = name
            self.value = value
        }
    }
}

/// A lexer/tokenizer to parse a HTML string into tokens representing the order of the various
/// elements. It is a non-validating HTML document parser. This means it will not check if the
/// HTML document structure is valid, but it _will_ check if the parsed HTML elements are valid
/// according to the HTML specification. Elements that could not be parsed are output as text.
///
/// Example: The string "`A <b>bold</b> move`" will output
/// ```
/// [
///     .text("A "),
///     .tagStart(name: "b", attributes: [], isSelfClosing: false),
///     .text("bold"),
///     .tagEnd(name: "b"),
///     .text(" move")
/// ]
/// ```
public final class HTMLLexer<Input>: Sequence, IteratorProtocol
where Input: Collection, Input.Element == Character {
    public typealias Element = HTMLToken

    private var reader: CharacterReader<Input>

    private var textStart: Input.Index

    private var textEnd: Input.Index

    private var queuedToken: HTMLToken?

    public init(html: Input) {
        self.reader = CharacterReader(input: html)
        self.textStart = html.startIndex
        self.textEnd = html.startIndex

        if let bom = consumeByteOrderMark() {
            self.queuedToken = bom
            textStart = reader.readIndex
        }
    }

    public func next() -> HTMLToken? {
        if let queuedToken {
            self.queuedToken = nil
            return queuedToken
        }
        return tagAndTextParser()
    }

    private func tagAndTextParser() -> HTMLToken? {
        while !reader.isAtEnd {
            reader.consume { $0 != "<" }
            textEnd = reader.readIndex
            if let tagToken = consumeTag() {
                if let textToken = accumulatedTextToken() {
                    queuedToken = tagToken
                    return textToken
                }
                textStart = reader.readIndex
                return tagToken
            }
        }
        textEnd = reader.readIndex
        return accumulatedTextToken()
    }

    private func accumulatedTextToken() -> HTMLToken? {
        if textStart == textEnd { return nil }
        let token: HTMLToken = .text(String(reader.input[textStart..<textEnd]))
        textStart = reader.readIndex
        return token
    }

    // MARK: - Reader helper functions

    private func isEndOfTag(_ character: Character) -> Bool {
        return character == ">" || character == "/"
    }

    private func consumeCharacter(_ character: Character) -> Bool {
        return character == reader.consume()
    }

    private func consumeCaseInsensitiveString(_ string: String) -> Input.SubSequence? {
        let startIndex = reader.readIndex
        for character in string {
            guard character.lowercased() == reader.consume()?.lowercased()
            else { return nil }
        }
        if reader.readIndex == startIndex {
            return nil
        }
        return reader.input[startIndex..<reader.readIndex]
    }

    private func consumeString(_ string: String) -> Bool {
        for character in string {
            guard character == reader.consume()
            else { return false }
        }
        return true
    }

    private func consumeUpToString(
        _ string: String,
        consumeMarker: Bool = true
    ) -> Input.SubSequence? {
        guard let firstChar = string.first
        else { return nil }
        let consumeStart = reader.readIndex
        readerLoop: while !reader.isAtEnd {
            reader.consume { $0 != firstChar }
            let foundStart = reader.readIndex
            for character in string {
                if character != reader.consume() {
                    continue readerLoop
                }
            }
            if !consumeMarker {
                reader.setReadIndex(foundStart)
            }
            return reader.input[consumeStart..<foundStart]
        }
        return nil
    }

    @discardableResult
    private func consume(minimum: Int, while predicate: (Input.Element) -> Bool) -> Bool {
        var count = 0
        reader.consume {
            if predicate($0) {
                count += 1
                return true
            }
            return false
        }
        return count >= minimum
    }

    @discardableResult
    private func consumeOneOrMore(_ predicate: (String.Element) -> Bool) -> Bool {
        return consume(minimum: 1, while: predicate)
    }

    @discardableResult
    private func consumeOneOrMore(_ characterSet: CharacterSet) -> Bool {
        return consumeOneOrMore { characterSet.contains($0) }
    }

    @discardableResult
    private func consumeZeroOrMore(_ predicate: (String.Element) -> Bool) -> Bool {
        reader.consume(while: predicate)
        return true
    }

    @discardableResult
    private func consumeZeroOrMore(_ characterSet: CharacterSet) -> Bool {
        return consumeZeroOrMore { characterSet.contains($0) }
    }

    // MARK: - Element parsers

    private func consumeByteOrderMark() -> HTMLToken? {
        // https://html.spec.whatwg.org/multipage/syntax.html#writing
        guard reader.peek() == "\u{FEFF}" else {
            return nil
        }
        reader.consume()
        return .byteOrderMark
    }

    private func consumeTag() -> HTMLToken? {
        guard
            consumeCharacter("<"),
            let nextCharacter = reader.peek()
        else { return nil }
        if nextCharacter == "/" {
            return consumeEndTag()
        } else if nextCharacter == "!" {
            return consumeMetaTag()
        }
        return consumeStartTag()
    }

    private func consumeMetaTag() -> HTMLToken? {
        let potentialTagIndex = reader.readIndex
        if let commentTag = consumeCommentTag() {
            return commentTag
        } else {
            reader.setReadIndex(potentialTagIndex)
            return consumeDoctypeTag()
        }
    }

    private func consumeCommentTag() -> HTMLToken? {
        // https://html.spec.whatwg.org/multipage/syntax.html#comments
        guard
            consumeString("!--"),
            let comment = consumeUpToString("-->")
        else { return nil }
        return .comment(String(comment))
    }

    private func consumeDoctypeTag() -> HTMLToken? {
        // https://html.spec.whatwg.org/multipage/syntax.html#the-doctype
        guard
            consumeCharacter("!"),
            let name = consumeCaseInsensitiveString("DOCTYPE"),
            consumeOneOrMore(.asciiWhitespace),
            let type = consumeCaseInsensitiveString("html"),
            consumeZeroOrMore(.asciiWhitespace),
            let nextChar = reader.peek()
        else { return nil }
        if nextChar == ">" {
            reader.consume()
            return .doctype(name: String(name), type: String(type), legacy: nil)
        }
        let legacyText = reader.consume(upTo: ">")
        guard consumeCharacter(">") else { return nil }
        return .doctype(name: String(name), type: String(type), legacy: String(legacyText))
    }

    private func consumeStartTag() -> HTMLToken? {
        // https://html.spec.whatwg.org/multipage/syntax.html#start-tags

        func consumeEndOfTag(isSelfClosing: inout Bool) -> Bool {
            var character = reader.consume()
            if character == "/" {
                isSelfClosing = true
                character = reader.consume()
            } else {
                isSelfClosing = false
            }
            return character == ">"
        }

        guard
            let name = consumeTagName(),
            let currentChar = reader.peek()
        else { return nil }
        if isEndOfTag(currentChar) {
            var isSelfClosing = false
            guard consumeEndOfTag(isSelfClosing: &isSelfClosing) else { return nil }
            return .tagStart(name: name, attributes: [], isSelfClosing: isSelfClosing)
        } else if CharacterSet.asciiWhitespace.contains(currentChar) {
            consumeOneOrMore(.asciiWhitespace)
        } else {
            return nil
        }

        let attributes = consumeTagAttributes()
        var isSelfClosing = false
        guard consumeEndOfTag(isSelfClosing: &isSelfClosing) else { return nil }
        return .tagStart(name: name, attributes: attributes, isSelfClosing: isSelfClosing)
    }

    private func consumeEndTag() -> HTMLToken? {
        // https://html.spec.whatwg.org/multipage/syntax.html#end-tags
        guard
            consumeCharacter("/"),
            let name = consumeTagName(),
            consumeZeroOrMore(.asciiWhitespace),
            consumeCharacter(">")
        else { return nil }
        return .tagEnd(name: name)
    }

    private func consumeTagName() -> String? {
        // https://html.spec.whatwg.org/multipage/syntax.html#syntax-tag-name
        let name = reader.consume(while: { CharacterSet.asciiAlphanumerics.contains($0) })
        return name.isEmpty ? nil : String(name)
    }

    private func consumeTagAttributes() -> [HTMLToken.TagAttribute] {
        // https://html.spec.whatwg.org/multipage/syntax.html#attributes-2
        var attributes: [HTMLToken.TagAttribute] = []
        while let nextChar = reader.peek(), !isEndOfTag(nextChar) {
            guard let tagAttribute = consumeTagAttribute() else {
                consumeZeroOrMore(.asciiWhitespace)
                continue
            }
            attributes.append(tagAttribute)
            consumeZeroOrMore(.asciiWhitespace)
        }
        return attributes
    }

    private func consumeTagAttribute() -> HTMLToken.TagAttribute? {
        // Attributes have several variants:
        // name
        // name \s* = \s* value
        // name \s* = \s* 'value'
        // name \s* = \s* "value"
        guard
            let name = consumeTagAttributeName(),
            consumeZeroOrMore(.asciiWhitespace),
            let nextChar = reader.peek()
        else { return nil }
        if isEndOfTag(nextChar) || nextChar != "=" {
            return .init(name: name, value: nil)
        }
        guard
            consumeCharacter("="),
            consumeZeroOrMore(.asciiWhitespace),
            let nextChar = reader.peek()
        else { return nil }
        if isEndOfTag(nextChar) {
            return .init(name: name, value: nil)
        }
        guard let value = consumeTagAttributeValue()
        else { return nil }
        return .init(name: name, value: value)
    }

    private func consumeTagAttributeName() -> String? {
        // https://html.spec.whatwg.org/multipage/syntax.html#syntax-attribute-name
        let name = reader.consume(while: { CharacterSet.htmlAttributeName.contains($0) })
        return name.isEmpty ? nil : String(name)
    }

    private func consumeTagAttributeValue() -> String? {
        guard let nextChar = reader.peek() else { return nil }
        if nextChar == "\"" || nextChar == "'" {
            return consumeTagAttributeQuotedValue()
        }
        return consumeTagAttributeUnquotedValue()
    }

    private func consumeTagAttributeQuotedValue() -> String? {
        guard
            let quote = reader.consume(),
            quote == "\"" || quote == "'"
        else { return nil }
        // TODO: Spec compliant value
        let value = reader.consume(upTo: quote)
        guard consumeCharacter(quote)
        else { return nil }
        return String(value)
    }

    private func consumeTagAttributeUnquotedValue() -> String? {
        let value = reader.consume(while: { CharacterSet.htmlNonQuotedAttributeValue.contains($0) })
        return value.isEmpty ? nil : String(value)
    }
}

extension HTMLLexer {
    public static func parse(html: Input) -> [HTMLToken] {
        return HTMLLexer(html: html).map { $0 }
    }
}
