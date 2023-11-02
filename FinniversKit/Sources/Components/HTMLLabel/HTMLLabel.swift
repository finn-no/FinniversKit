public class HTMLLabel: Label {
    private var htmlText: String?
    private let spanMapper: HTMLStringUIKitStyleTranslator.SpanMapper
    private var additionalSpanMapper: HTMLStringUIKitStyleTranslator.SpanMapper = { _, _ in }

    public override var textColor: UIColor! {
        didSet {
            guard let htmlText else { return }

            setAttributedString(from: htmlText)
        }
    }

    public init(style: Style, spanMapper: @escaping HTMLStringUIKitStyleTranslator.SpanMapper = { _, _ in }, withAutoLayout: Bool = false) {
        self.spanMapper = spanMapper
        super.init(style: style, withAutoLayout: withAutoLayout)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setHTMLText(
        _ htmlText: String,
        additionalSpanMapper: @escaping HTMLStringUIKitStyleTranslator.SpanMapper = { _, _ in }
    ) {
        self.htmlText = htmlText
        self.additionalSpanMapper = additionalSpanMapper
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
                foregroundColor: textColor,
                spanMapper: { attributes, currentStyle in
                    self.spanMapper(attributes, &currentStyle)
                    self.additionalSpanMapper(attributes, &currentStyle)
                }
            )
            attributedText = try htmlParser.parse(html: htmlString, translator: translator)
        } catch {
            text = htmlString
        }
    }
}
