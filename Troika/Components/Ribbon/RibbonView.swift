import UIKit

class RibbonView: UIView {

    // Mark: - Internal properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .detail
        label.textColor = .licorice // TODO: Spør om det skal være ´stone´?
        return label
    }()
    
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
        addSubview(titleLabel)
        backgroundColor = .clear
    }

    // Mark: - Superclass Overrides

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }

    // Mark: - Dependency injection
    
    public var presentable: RibbonPresentable? {
        didSet {
            titleLabel.text = presentable?.title
            titleLabel.backgroundColor = presentable?.type.color
        }
    }
    
    // Mark: - Private

}

public protocol RibbonPresentable {
    var type: RibbonType { get }
    var title: String { get }
}

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
