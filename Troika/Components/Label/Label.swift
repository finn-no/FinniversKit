import UIKit

public class Label: UILabel {

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
        let insets = UIEdgeInsets(top: style.padding.top, left: style.padding.left, bottom: style.padding.bottom, right: style.padding.right)
        let string = NSString(string: text)
        string.draw(at: UIEdgeInsetsInsetRect(rect, insets).origin, withAttributes: style.attributes)
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            guard let style = style, let text = text else {
                return super.intrinsicContentSize
            }
            let string = NSString(string: text)
            var textSize = string.size(withAttributes: style.attributes)
            textSize.height += style.padding.top + style.padding.bottom
            textSize.width += style.padding.left + style.padding.right
            return textSize
        }
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

