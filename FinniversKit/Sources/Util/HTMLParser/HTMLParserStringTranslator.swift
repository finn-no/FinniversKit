import Foundation

public struct HTMLParserStringTranslator: HTMLParserTranslator {
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

    public func translate(tokens: [HTMLParser.Token]) -> String {
        var html = ""
        for token in tokens {
            switch token {
            case .comment(let comment):
                if stripAllHTMLElements { continue }
                html.append("<!--\(comment)-->")

            case .elementBegin(let name, let attributes):
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
                html.append("<\(name)\(attributesText)>")

            case .elementEnd(let name):
                if stripAllHTMLElements { continue }
                if omitHTMLDocumentElements, name.lowercased() == "html" { continue }
                html.append("</\(name)>")

            case .text(let text):
                html.append(text)
            }
        }
        return html
    }
}
