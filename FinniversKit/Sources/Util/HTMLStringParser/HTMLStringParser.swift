import Foundation

public protocol HTMLStringParserTranslator {
    associatedtype Output

    func translate(tokens: [HTMLToken]) throws -> Output
}

public struct HTMLStringParser {
    public static func parse<Translator>(
        html: String,
        translator: Translator
    ) throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        let tokens = HTMLLexer.parse(html: html)
        return try parse(tokens: tokens, translator: translator)
    }

    public static func parse<Translator>(
        tokens: [HTMLToken],
        translator: Translator
    ) throws -> Translator.Output where Translator: HTMLStringParserTranslator {
        return try translator.translate(tokens: tokens)
    }
}
