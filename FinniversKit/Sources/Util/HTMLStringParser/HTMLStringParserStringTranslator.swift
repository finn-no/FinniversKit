import Foundation

public struct HTMLStringParserStringTranslator: HTMLStringParserTranslator {
    /// Removes begin and end HTML elements.
    public var omitHTMLDocumentElements: Bool
    /// Removes all HTML elements to get pure text.
    public var stripAllHTMLElements: Bool

    public init(
        omitHTMLDocumentElements: Bool = true,
        stripAllHTMLElements: Bool = true
    ) {
        self.omitHTMLDocumentElements = omitHTMLDocumentElements
        self.stripAllHTMLElements = stripAllHTMLElements
    }

    public func translate(tokens: [HTMLLexer.Token]) -> String {
        var html = ""
        for token in tokens {
            switch token {
            case .beginTag(let name, let attributes, let isSelfClosing):
                let nameLower = name.lowercased()
                if stripAllHTMLElements {
                    if nameLower == "br" {
                        html.append("\n")
                    }
                    continue
                }
                if omitHTMLDocumentElements, nameLower == "html" { continue }
                var attributesText = ""
                if !attributes.isEmpty {
                    attributesText = attributes.reduce(into: "", { partialResult, keyAndValue in
                        partialResult.append(" \(keyAndValue.key)=\"\(keyAndValue.value)\"")
                    })
                }
                html.append("<\(name)\(attributesText)\(isSelfClosing ? "/" : "")>")

            case .endTag(let name):
                if stripAllHTMLElements { continue }
                if omitHTMLDocumentElements, name.lowercased() == "html" { continue }
                html.append("</\(name)>")

            case .text(let text):
                html.append(text)

            case .commentTag(let comment):
                if stripAllHTMLElements { continue }
                html.append("<!--\(comment)-->")

            case .doctypeTag(let type, let legacy):
                if stripAllHTMLElements || omitHTMLDocumentElements { continue }
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
