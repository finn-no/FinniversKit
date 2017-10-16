import UIKit

public class Label: UILabel {
    
    // Mark: - Internal properties
    
    var labelAttributes: [NSAttributedStringKey : Any] {
        guard let style = style else {
            return [:]
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = style.lineSpacing
        paragraphStyle.alignment = textAlignment
        
        return [
            NSAttributedStringKey.font: style.font,
            NSAttributedStringKey.foregroundColor: style.color,
            NSAttributedStringKey.paragraphStyle: paragraphStyle
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
    
    public override func drawText(in rect: CGRect) {
        guard let style = style, let text = text else {
            return
        }
        let string = NSString(string: text)
        let textRect = CGRect(x: style.padding.left, y: style.padding.top, width: rect.width - style.padding.left - style.padding.right, height: rect.height - style.padding.top - style.padding.bottom)
        string.draw(in: textRect, withAttributes: labelAttributes)
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            guard let style = style, let text = text else {
                return super.intrinsicContentSize
            }
            var textSize = size(of: text)
            textSize.height = ceil(textSize.height + style.padding.top + style.padding.bottom)
            textSize.width = ceil(textSize.width + style.padding.left + style.padding.right)
            return textSize
        }
    }
    
    func size(of text: String) -> CGSize {
        let string = NSString(string: text)
        let textSize = string.size(withAttributes: labelAttributes)
        return textSize
    }

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

