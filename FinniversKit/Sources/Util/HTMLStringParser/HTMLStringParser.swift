import Foundation

public protocol HTMLStringParserTranslator {
    associatedtype Output

    func translate(tokens: [HTMLLexer.Token]) throws -> Output
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
        tokens: [HTMLLexer.Token],
        translator: Translator
    ) throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        return try translator.translate(tokens: tokens)
    }

    public func parse<Translator>(
        tokens: [HTMLLexer.Token],
        translator: Translator
    ) async throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                let output = try translator.translate(tokens: tokens)
                continuation.resume(returning: output)
            }
        }
    }

    public func tokenize(html: String) -> [HTMLLexer.Token] {
        let delegate = LexerDelegate()
        let lexer = HTMLLexer(html: html)
        lexer.delegate = delegate
        lexer.read()
        return delegate.tokens
    }

    public func tokenize(html: String) async -> [HTMLLexer.Token] {
        return await withCheckedContinuation { continuation in
            Task {
                let tokens = tokenize(html: html)
                continuation.resume(returning: tokens)
            }
        }
    }
}

extension HTMLStringParser {
    private final class LexerDelegate: HTMLLexerDelegate {
        private(set) var tokens: [HTMLLexer.Token] = []

        // MARK: - HTMLLexerDelegate

        func lexer(_ lexer: HTMLLexer, didFindToken token: HTMLLexer.Token) {
            tokens.append(token)
        }
    }
}
