public class HTMLLabel: Label {
    private var htmlText: String?
    private var styleMap: HTMLStyler.StyleMap
    private var additionalStyleMap: HTMLStyler.StyleMap?

    public override var textColor: UIColor! {
        didSet {
            styleMap[.textColor] = textColor
        }
    }

    public init(style: Style, styleMap: HTMLStyler.StyleMap = [:], withAutoLayout: Bool = false) {
        self.styleMap = styleMap
        super.init(style: style, withAutoLayout: withAutoLayout)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setHTMLText(_ htmlText: String, with additionalStyleMap: HTMLStyler.StyleMap = [:]) {
        self.htmlText = htmlText
        self.additionalStyleMap = additionalStyleMap
        setAttributedString(from: htmlText)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // Overriding this function makes sure that the label always adapts to the
        // new trait collection automatically (e.g. when changing from light to dark mode).
        super.traitCollectionDidChange(previousTraitCollection)

        guard
            let htmlText = htmlText
        else {
            return
        }

        setAttributedString(from: htmlText)
    }

    private func setAttributedString(from htmlString: String) {
        do {
            let htmlParser = HTMLStringParser()
            let translator = HTMLStringUIKitStyleTranslator.finnStyle(
                font: font,
                foregroundColor: textColor
            )
            attributedText = try htmlParser.parse(html: htmlString, translator: translator)
        } catch {
            text = htmlString
        }
    }
}
