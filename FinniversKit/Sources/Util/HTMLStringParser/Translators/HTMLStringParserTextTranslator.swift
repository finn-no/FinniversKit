import Foundation

public struct HTMLStringParserTextTranslator: HTMLStringParserTranslator {
    public init() {}

    public func translate(tokens: [HTMLToken]) -> String {
        var text = ""
        for token in tokens {
            switch token {
            case .tagStart(let name, _, _):
                let nameLower = name.lowercased()
                if nameLower == "br" {
                    text.append("\n")
                }

            case .text(let htmlText):
                text.append(htmlText)

            default:
                break
            }
        }
        return text
    }
}
