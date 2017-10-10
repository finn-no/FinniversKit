import UIKit

public enum LabelStyle {
    case t1
    case t2
    case t3
    case t4
    case body
    case detail
    
    var color: UIColor {
        switch self {
        case .t1: return .licorice
        case .t2: return .licorice
        case .t3: return .licorice
        case .t4: return .licorice
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
        case .body: return UIFont.body
        case .detail: return UIFont.detail
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

