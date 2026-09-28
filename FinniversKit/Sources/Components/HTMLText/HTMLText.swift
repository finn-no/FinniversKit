import SwiftUI

public struct HTMLText: View {
    public let html: String
    public let spanMapper: HTMLStringSwiftUIStyleTranslator.SpanMapper

    private var font: Font?
    private var foregroundColor: Color?

    public init(
        _ html: String,
        spanMapper: @escaping HTMLStringSwiftUIStyleTranslator.SpanMapper = { _, _ in }
    ) {
        self.html = html
        self.spanMapper = spanMapper
    }

    public var body: some View {
        htmlTextHelper()
    }

    private func htmlTextHelper() -> some View {
        do {
            let translator = HTMLStringSwiftUIStyleTranslator.finnStyle(
                font: font,
                foregroundColor: foregroundColor,
                spanMapper: spanMapper
            )
            let styledTexts = try HTMLStringParser.parse(html: html, translator: translator)
            return styledTexts.reduce(
                into: Text("").applyStyle(translator.styleStack.defaultStyle)
            ) { textView, styledText in
                let newText: Text
                if let url = styledText.url {
                    newText = Text("\(styledText.text, link: url)")
                } else {
                    newText = Text(styledText.text)
                }
                textView = textView + newText
                    .applyStyle(styledText.style)
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
            HTMLText("<p>This is <i>a paragraph</i>.</p><p>And this is another one.</p>")

            HTMLText("<ul><li>List element one</li><li>List element two</li><li>List element three</li></ul>")

            HTMLText("This is <b>bold</b> stuff.")
                .font(.largeTitle)

            HTMLText("Linebreak<br>is needed.")
                .foregroundColor(.green)

            HTMLText("Shipping costs <span style=\"color:tjt-price-highlight\">60 NOK</span>")

            HTMLText("Old price is <del>80 NOK</del>")

            HTMLText("A <a href=\"https://google.com\">link</a>")
        }
        .previewLayout(.sizeThatFits)
    }
}
