import SwiftUI

public struct HTMLText: View {
    public let html: String

    private var font: Font?
    private var foregroundColor: Color?

    public init(_ html: String) {
        self.html = html
    }

    public var body: some View {
        htmlTextHelper()
    }

    private func htmlTextHelper() -> some View {
        do {
            let htmlParser = HTMLStringParser()
            let translator = HTMLStringSwiftUIStyleTranslator.finnStyle(
                font: font,
                foregroundColor: foregroundColor
            )
            let styledTexts = try htmlParser.parse(html: html, translator: translator)
            return styledTexts.reduce(
                into: Text("").applyStyle(translator.styleStack.defaultStyle)
            ) { textView, styledText in
                textView = textView + Text(styledText.text).applyStyle(styledText.style)
            }
        } catch {
            return Text(html)
        }
    }

    public func font(_ font: Font?) -> HTMLText {
        var text = self
        text.font = font
        return text
    }

    public func foregroundColor(_ color: Color?) -> HTMLText {
        var text = self
        text.foregroundColor = color
        return text
    }
}

extension Text {
    fileprivate func applyStyle(_ style: HTMLStringSwiftUIStyleTranslator.Style) -> Text {
        var text = self
        if let font = style.font {
            text = text.font(font)
        }
        if let fontWeight = style.fontWeight {
            text = text.fontWeight(fontWeight)
        }
        if let foregroundColor = style.foregroundColor {
            text = text.foregroundColor(foregroundColor)
        }
        if let italic = style.italic, italic == true {
            text = text.italic()
        }
        if let strikethrough = style.strikethrough, strikethrough == true {
            text = text.strikethrough(color: style.strikethroughColor)
        }
        if let underline = style.underline, underline == true {
            text = text.underline(color: style.underlineColor)
        }
        return text
    }
}

struct HTMLText_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HTMLText("This is <b>bold</b> stuff.")
                .font(.largeTitle)

            HTMLText("Linebreak<br>is needed.")
                .foregroundColor(.green)

            HTMLText("Shipping costs <span style=\"color:tjt-price-highlight\">60 NOK</span>")

            HTMLText("Old price is <del>80 NOK</del>")
        }
        .previewLayout(.sizeThatFits)
    }
}
