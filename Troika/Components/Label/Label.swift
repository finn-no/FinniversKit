import UIKit

public enum LabelStyle {
    case t1
    case t2
    case t3
    case t4
    case t5
    case body
    case detail
    
    var color: UIColor {
        switch self {
        case .t1: return .licorice
        case .t2: return .licorice
        case .t3: return .licorice
        case .t4: return .licorice
        case .t5: return .licorice
        case .body: return .licorice
        case .detail: return .stone
        }
    }
    
    var font: UIFont {
        switch self {
        case .t1: return UIFont.t1
        case .t2: return UIFont.t2
        case .t3: return UIFont.t3
        case .t4: return UIFont.t4
        case .t5: return UIFont.t5
        case .body: return UIFont.body
        case .detail: return UIFont.detail
        }
    }
    
    var padding: UIEdgeInsets {
        switch self {
        case .t1: return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        case .t2: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .t3: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .t4: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .t5: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .body: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .detail: return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

public class Label: UILabel {

    // Mark: - Internal properties
    
    // Mark: - External properties

    // Mark: - Setup
    
    public init(style: LabelStyle) {
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
        textColor = style?.color
        font = style?.font
    }

    // Mark: - Superclass Overrides
    
    public override func drawText(in rect: CGRect) {
        guard let style = style else {
            return
        }
        let insets = UIEdgeInsets(top: style.padding.top, left: style.padding.left, bottom: style.padding.bottom, right: style.padding.right)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += style!.padding.top + style!.padding.bottom
            contentSize.width += style!.padding.left + style!.padding.right
            return contentSize
        }
    }

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        // Add custom subviews
        // Layout your custom views
    }

    // Mark: - Dependency injection
    
    public var style: LabelStyle? {
        didSet {
            textColor = style?.color
            font = style?.font
        }
    }
    
    // Mark: - Private

}

