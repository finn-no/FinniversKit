import UIKit

public enum ToastType {
    case success
    case sucesssImage
    case error
    case button
    
    var color: UIColor {
        switch self {
        case .error:
            return .salmon
        default:
            return .mint
        }
    }
}

public class ToastView: UIView {

    // Mark: - Internal properties
    
    private lazy var messageTitle: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style = .body(.licorice)
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
        // Perform setup
    }

    // Mark: - Superclass Overrides

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        // Add custom subviews
        // Layout your custom views
    }

    // Mark: - Dependency injection

    // Mark: - Private

}

