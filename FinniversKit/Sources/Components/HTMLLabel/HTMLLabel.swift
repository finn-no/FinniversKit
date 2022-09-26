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
        super.traitCollectionDidChange(previousTraitCollection)
        guard
            let htmlText = htmlText,
            UIApplication.shared.applicationState != .background
        else {
            return
        }

        setAttributedString(from: htmlText)
    }

    private func setAttributedString(from htmlString: String) {
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
