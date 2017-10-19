import UIKit

public enum ToastType {
    case success
    case sucesssImage
    case error
    case button
    
    var color: UIColor {
        switch self {
        case .error: return .salmon
        default: return .mint
        }
    }
    
    var imageIcon: UIImage {
        switch self {
        case .error: return UIImage(frameworkImageNamed: "error")!
        case .sucesssImage: return UIImage(frameworkImageNamed: "NoImage")!
        default: return UIImage(frameworkImageNamed: "success")!
        }
    }
}

public class ToastView: UIView {

    // Mark: - Internal properties
    
    private let cornerRadius: CGFloat = 2
    private let imageSizeAllowedMin = CGSize(width: 18, height: 18)
    private let imageSizeAllowedMax = CGSize(width: 26, height: 26)
    
    private lazy var messageTitle: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.style = .body(.licorice)
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.primaryBlue, for: .normal)
        button.layer.masksToBounds = true
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private weak var delegate: ToastViewDelegate?


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
        layer.cornerRadius = cornerRadius
        isAccessibilityElement = true
        
        addSubview(imageView)
        addSubview(messageTitle)
        addSubview(actionButton)
    }

    // Mark: - Superclass Overrides

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CGFloat.mediumLargeSpacing).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualToConstant: imageSizeAllowedMax.width).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: imageSizeAllowedMax.height).isActive = true
        imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: imageSizeAllowedMin.width).isActive = true
        imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: imageSizeAllowedMin.height).isActive = true
        
        messageTitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: CGFloat.mediumLargeSpacing).isActive = true
        messageTitle.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat.mediumLargeSpacing).isActive = true
        messageTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -CGFloat.mediumLargeSpacing).isActive = true
        
        if let presentable = presentable, presentable.actionButtonTitle != nil {
            actionButton.isHidden = false
            messageTitle.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: CGFloat.mediumLargeSpacing).isActive = true

            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CGFloat.mediumLargeSpacing).isActive = true
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        } else {
            actionButton.isHidden = true
            messageTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CGFloat.mediumLargeSpacing).isActive = true
        }
    }

    // Mark: - Dependency injection
    
    public var presentable: ToastPresentable? {
        didSet {
            messageTitle.text = presentable?.messageTitle
            accessibilityLabel = presentable?.accessibilityLabel
            imageView.image = presentable?.type.imageIcon
            backgroundColor = presentable?.type.color
            actionButton.setTitle(presentable?.actionButtonTitle, for: .normal)
            
            if presentable?.type == .sucesssImage {
                imageView.backgroundColor = .milk
            }
        }
    }

    // Mark: - Private

}

