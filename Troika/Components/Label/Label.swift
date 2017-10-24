import UIKit

public class Label: UILabel {

    // Mark: - Internal properties

    var labelAttributes: [NSAttributedStringKey: Any] {
        guard let style = style else {
            return [:]
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = style.lineSpacing
        paragraphStyle.alignment = textAlignment

        return [
            NSAttributedStringKey.font: style.font,
            NSAttributedStringKey.foregroundColor: style.color,
            NSAttributedStringKey.paragraphStyle: paragraphStyle,
        ]
    }

    // Mark: - Setup

    public init(style: Style) {
        super.init(frame: .zero)
        self.style = style
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true
    }

    // Mark: - Superclass Overrides

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        accessibilityLabel = text
        textColor = style?.color
        font = style?.font
    }

    // Mark: - Dependency injection

    public var style: Style?
}
