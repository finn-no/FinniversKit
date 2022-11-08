import Foundation

public struct HTMLStringParserHTMLTranslator: HTMLStringParserTranslator {
    public init() {}

    public func translate(tokens: [HTMLLexer.Token]) -> String {
        var html = ""
        for token in tokens {
            switch token {
            case .startTag(let name, let attributes, let isSelfClosing):
                var attributesText = ""
                if !attributes.isEmpty {
                    attributesText = attributes.reduce(into: "", { partialResult, keyAndValue in
                        partialResult.append(" \(keyAndValue.key)=\"\(keyAndValue.value)\"")
                    })
                }
                html.append("<\(name)\(attributesText)\(isSelfClosing ? "/" : "")>")

            case .endTag(let name):
                html.append("</\(name)>")

            case .text(let text):
                html.append(text)

            case .commentTag(let comment):
                html.append("<!--\(comment)-->")

            case .doctypeTag(let type, let legacy):
                var doctype = "<!DOCTYPE \(type)"
                if let legacy = legacy {
                    doctype.append(" \(legacy)")
                }
                doctype.append(">")
                html.append(doctype)
            }
        }
        return html
    }
}
