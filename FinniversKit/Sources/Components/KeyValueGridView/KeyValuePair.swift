public struct KeyValuePair: Hashable {
    public let title: String
    public let value: String
    public let accessibilityLabel: String?
    public let valueStyle: Style?
    public let valueImage: UIImage?
    public let infoTooltip: String?
    public let infoTooltipAccessibilityLabel: String?

    public init(
        title: String,
        value: String,
        accessibilityLabel: String? = nil,
        valueStyle: Style? = nil,
        valueImage: UIImage? = nil,
        infoTooltip: String? = nil,
        infoTooltipAccessibilityLabel: String? = nil
    ) {
        self.title = title
        self.value = value
        self.accessibilityLabel = accessibilityLabel
        self.valueStyle = valueStyle
        self.valueImage = valueImage
        self.infoTooltip = infoTooltip
        self.infoTooltipAccessibilityLabel = infoTooltipAccessibilityLabel
    }
}

extension KeyValuePair {
    public struct Style: Hashable {
        public let textColor: UIColor
        public let backgroundColor: UIColor
        public let horizontalPadding: CGFloat

        public init(textColor: UIColor, backgroundColor: UIColor, horizontalPadding: CGFloat = 0) {
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.horizontalPadding = horizontalPadding
        }
    }
}
