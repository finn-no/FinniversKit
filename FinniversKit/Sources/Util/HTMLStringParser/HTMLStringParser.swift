import Foundation

public protocol HTMLStringParserTranslator {
    associatedtype Output

    func translate(tokens: [HTMLStringLexer.Token]) throws -> Output
}

public struct HTMLStringParser {
    public init() {}

    public func parse<Translator>(
        html: String,
        translator: Translator
    ) throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        let tokens = tokenize(html: html)
        return try parse(tokens: tokens, translator: translator)
    }

    public func parse<Translator>(
        html: String,
        translator: Translator
    ) async throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        let tokens = await tokenize(html: html)
        return try await parse(tokens: tokens, translator: translator)
    }

    public func parse<Translator>(
        tokens: [HTMLStringLexer.Token],
        translator: Translator
    ) throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        return try translator.translate(tokens: tokens)
    }

    public func parse<Translator>(
        tokens: [HTMLStringLexer.Token],
        translator: Translator
    ) async throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let output = try translator.translate(tokens: tokens)
                continuation.resume(returning: output)
            }
        }
    }

    public func tokenize(html: String) -> [HTMLStringLexer.Token] {
        let delegate = LexerDelegate()
        let lexer = HTMLStringLexer(delegate: delegate)
        lexer.read(html: html)
        return delegate.tokens
    }

    public func tokenize(html: String) async -> [HTMLStringLexer.Token] {
        return await withCheckedContinuation { continuation in
            Task {
                let tokens = tokenize(html: html)
                continuation.resume(returning: tokens)
            }
        }
    }
}

extension HTMLStringParser {
    private final class LexerDelegate: HTMLStringLexerDelegate {
        private(set) var tokens: [HTMLStringLexer.Token] = []

        // MARK: - HTMLStringLexerDelegate

        func lexer(
            _ lexer: HTMLStringLexer,
            foundToken token: HTMLStringLexer.Token
        ) {
            tokens.append(token)
        }
    }
}
