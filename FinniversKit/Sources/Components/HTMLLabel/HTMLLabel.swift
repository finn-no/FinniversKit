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
        // We can not update the (html) attributed string when the app is in the background or it will crash. This can potentially lead to a label that is not getting set
        guard UIApplication.shared.applicationState != .background else { return }

        var styledText = "<span style=\"font-family: \(font.fontName); font-size: \(font.pointSize); color: text-color\">\(htmlString)</span>"
        let combinedStyleMap = styleMap.merging(additionalStyleMap ?? [:], uniquingKeysWith: { $1 })
        for (styleIdentifier, styleColor) in combinedStyleMap {
            let colorHexValue = styleColor.resolvedColor(with: traitCollection).hexString
            styledText = styledText.replacingOccurrences(of: styleIdentifier.rawValue, with: colorHexValue)
        }

        // Setting the default text color if it's not defined in the style map.
        styledText = styledText.replacingOccurrences(of: "text-color", with: textColor.hexString)

        guard
            let data = styledText.data(using: .unicode),
            let attrStr = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
        else {
            return
        }

        attributedText = attrStr
    }
}
