import SwiftUI

public struct HTMLText: View {
    public let html: String

    private let htmlParser: HTMLStringParser

    public init(_ html: String) {
        self.html = html
        self.htmlParser = HTMLStringParser()
    }

    public var body: some View {
        htmlTextHelper()
    }

    private func htmlTextHelper() -> some View {
        do {
            return try htmlParser.parse(html: html, translator: finnTextViewTranslator)
        } catch {
            return Text(html)
        }
    }

    private var finnTextViewTranslator: HTMLStringParserTextViewTranslator = {
        return HTMLStringParserTextViewTranslator(defaultStyle: .init(
            font: .finnFont(.body),
            foregroundColor: .textPrimary
        )) { elementName, attributes in
            var style = HTMLStringParserTextViewTranslator.Style()
            switch elementName.lowercased() {
            case "b":
                style.fontWeight = .bold
            case "span":
                if let styleAttrib = attributes["style"], styleAttrib == "color:tjt-price-highlight" {
                    style.foregroundColor = .textCritical
                }
            case "del":
                style.strikethrough = true
            default:
                break
            }
            return style
        }
    }()
}

struct HTMLText_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HTMLText("This is <b>bold</b> stuff.")

            HTMLText("Linebreak<br>is needed.")

            HTMLText("Shipping costs <span style=\"color:tjt-price-highlight\">60 NOK</span>")

            HTMLText("Old price is <del>80 NOK</del>")
        }
        .previewLayout(.sizeThatFits)
    }
}
