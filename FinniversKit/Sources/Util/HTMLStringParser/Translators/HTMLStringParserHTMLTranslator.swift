import Foundation

public struct HTMLStringParserHTMLTranslator: HTMLStringParserTranslator {
    public init() {}

    public func translate(tokens: [HTMLToken]) -> String {
        var html = ""
        for token in tokens {
            switch token {
            case .tagStart(let name, let attributes, let isSelfClosing):
                var attributesText = ""
                if !attributes.isEmpty {
                    attributesText = attributes.reduce(into: "", { partialResult, attribute in
                        partialResult.append(" \(attribute.name)")
                        if let value = attribute.value {
                            // This assumes value is already HTML spec compliant with proper escapes
                            if value.contains(where: { $0 == "\"" }) {
                                partialResult.append("='\(value)'")
                            } else {
                                partialResult.append("=\"\(value)\"")
                            }
                        }
                    })
                }
                html.append("<\(name)\(attributesText)\(isSelfClosing ? "/" : "")>")

            case .tagEnd(let name):
                html.append("</\(name)>")

            case .text(let text):
                html.append(text)

            case .comment(let comment):
                html.append("<!--\(comment)-->")

            case .doctype(let name, let type, let legacy):
                var doctype = "<!\(name) \(type)"
                if let legacy = legacy {
                    doctype.append(" \(legacy)")
                }
                doctype.append(">")
                html.append(doctype)

            case .byteOrderMark:
                html.append("\u{FEFF}")
            }
        }
        return html
    }
}
