import Foundation

public protocol HTMLParserTranslator {
    associatedtype Output

    func translate(tokens: [HTMLParser.Token]) throws -> Output
}

public enum HTMLParserError: Error {
    case unknownXMLParserError
    case utf8DataConversionFailed(String)
}

public struct HTMLParser {
    public enum Token: Equatable {
        case comment(String)
        case elementBegin(name: String, attributes: [String: String])
        case elementEnd(name: String)
        case text(String)
    }

    public init() {}

    public func parse<Translator>(
        html: String,
        translator: Translator
    ) throws -> Translator.Output where Translator: HTMLParserTranslator {
        let tokens = try tokenize(html: html)
        return try parse(tokens: tokens, translator: translator)
    }

    public func parse<Translator>(
        html: String,
        translator: Translator
    ) async throws -> Translator.Output where Translator: HTMLParserTranslator {
        let tokens = try await tokenize(html: html)
        return try await parse(tokens: tokens, translator: translator)
    }

    public func parse<Translator>(
        tokens: [Token],
        translator: Translator
    ) throws -> Translator.Output where Translator: HTMLParserTranslator {
        return try translator.translate(tokens: tokens)
    }

    public func parse<Translator>(
        tokens: [Token],
        translator: Translator
    ) async throws -> Translator.Output where Translator: HTMLParserTranslator {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let output = try translator.translate(tokens: tokens)
                continuation.resume(returning: output)
            }
        }
    }

    public func tokenize(html: String) throws -> [Token] {
        var parsableHtml = html
        if !html.hasPrefix("<") {
            parsableHtml = "<!DOCTYPE HTML><html>\(html)</html>"
        }
        guard let data = parsableHtml.data(using: .utf8) else {
            throw HTMLParserError.utf8DataConversionFailed(parsableHtml)
        }
        let parser = XMLParser(data: data)
        let lexer = Lexer()
        parser.delegate = lexer
        guard parser.parse() else {
            if let parserError = parser.parserError {
                throw parserError
            }
            throw HTMLParserError.unknownXMLParserError
        }
        return lexer.tokens
    }

    public func tokenize(html: String) async throws -> [Token] {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let tokens = try tokenize(html: html)
                continuation.resume(returning: tokens)
            }
        }
    }
}

extension HTMLParser {
    private final class Lexer: NSObject, XMLParserDelegate {
        private(set) var tokens: [Token] = []
        private var currentText = ""

        private func addTextToken() {
            guard !currentText.isEmpty else { return }
            tokens.append(.text(currentText))
            currentText = ""
        }

        private func addElementBeginToken(_ name: String, attributes: [String: String]) {
            addTextToken()
            tokens.append(.elementBegin(name: name, attributes: attributes))
        }

        private func addElementEndToken(_ name: String) {
            addTextToken()
            tokens.append(.elementEnd(name: name))
        }

        private func addCommentToken(_ comment: String) {
            addTextToken()
            tokens.append(.comment(comment))
        }

        // MARK: - XMLParserDelegate

        func parser(
            _ parser: XMLParser,
            didStartElement elementName: String,
            namespaceURI: String?,
            qualifiedName qName: String?,
            attributes attributeDict: [String: String] = [:]
        ) {
            addElementBeginToken(elementName, attributes: attributeDict)
        }

        func parser(
            _ parser: XMLParser,
            didEndElement elementName: String,
            namespaceURI: String?,
            qualifiedName qName: String?
        ) {
            addElementEndToken(elementName)
        }

        func parser(
            _ parser: XMLParser,
            foundCharacters string: String
        ) {
            currentText.append(string)
        }

        func parser(
            _ parser: XMLParser,
            foundComment comment: String
        ) {
            addCommentToken(comment)
        }
    }
}
