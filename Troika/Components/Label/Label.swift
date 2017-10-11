import UIKit

public class Label: UILabel {

    // Mark: - Internal properties
    
    // Mark: - External properties

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
        guard let style = style else {
            super.drawText(in: rect)
            return
        }
        let insets = UIEdgeInsets(top: style.padding.top, left: style.padding.left, bottom: style.padding.bottom, right: style.padding.right)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            guard let style = style else {
                return super.intrinsicContentSize
            }
            var contentSize = super.intrinsicContentSize
            contentSize.height += style.padding.top + style.padding.bottom
            contentSize.width += style.padding.left + style.padding.right
            return contentSize
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
    
    // Mark: - Private

}

