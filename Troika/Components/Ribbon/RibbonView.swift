import UIKit

public enum RibbonType {
    case ordinary
    case success
    case warning
    case error
    case disabled
    case sponsored
    
    var color: UIColor {
        switch self {
        case .ordinary: return .ice
        case .success: return .mint
        case .warning: return .banana
        case .error: return .salmon
        case .disabled: return .sardine
        case .sponsored: return .toothPaste
        }
    }
}

public class RibbonView: UIView {

    // Mark: - Internal properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .detail
        label.textColor = .licorice // TODO: Spør om det skal være ´stone´?
        return label
    }()
    
    let horisontalMargin: CGFloat = 8
    let verticalMargin: CGFloat = 2
    
    // Mark: - External properties

    // Mark: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 3
        addSubview(titleLabel)
    }

    // Mark: - Superclass Overrides

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horisontalMargin).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horisontalMargin).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin).isActive = true
    }

    // Mark: - Dependency injection
    
    public var presentable: RibbonPresentable? {
        didSet {
            titleLabel.text = presentable?.title
            backgroundColor = presentable?.type.color
        }
    }
    
    // Mark: - Private

}

