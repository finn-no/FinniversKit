import SwiftUI
import UIKit

public struct HTMLText: View {
    public let html: String

    public init(_ html: String) {
        self.html = html
    }

    public var body: some View {
        htmlTextHelper()
    }

    private func htmlTextHelper() -> some View {
        do {
            let htmlParser = HTMLStringParser()
            let translator = HTMLStringParserStyleTranslator.finnStyle
            let styledTexts = try htmlParser.parse(html: html, translator: translator)
            return styledTexts.reduce(into: Text("").applyStyle(translator.defaultStyle)) { textView, styledText in
                textView = textView + Text(styledText.text).applyStyle(styledText.style)
            }
        } catch {
            return Text(html)
        }
    }
}

extension Text {
    fileprivate func applyStyle(_ style: HTMLStringParserStyleTranslator.Style) -> Text {
        var text = self
        if let font = style.font {
            text = text.font(Font(font))
        }
        if let fontWeight = style.fontWeight {
            text = text.fontWeight(Font.Weight(fontWeight))
        }
        if let foregroundColor = style.foregroundColor {
            text = text.foregroundColor(Color(foregroundColor))
        }
        if let italic = style.italic, italic == true {
            text = text.italic()
        }
        if let strikethrough = style.strikethrough, strikethrough == true {
            var color: Color?
            if let strikethroughColor = style.strikethroughColor {
                color = Color(strikethroughColor)
            }
            text = text.strikethrough(color: color)
        }
        if let underline = style.underline, underline == true {
            var color: Color?
            if let underlineColor = style.underlineColor {
                color = Color(underlineColor)
            }
            text = text.underline(color: color)
        }
        return text
    }
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
