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
        tokens: [HTMLLexer.Token],
        translator: Translator
    ) throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        return try translator.translate(tokens: tokens)
    }

    public func tokenize(html: String) -> [HTMLLexer.Token] {
        let delegate = LexerDelegate()
        let lexer = HTMLLexer()
        lexer.delegate = delegate
        lexer.read(html: html)
        return delegate.tokens
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
