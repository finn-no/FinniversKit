import UIKit

public protocol PromotionViewDelegate: AnyObject {
    func didSelectChristmasPromotion(_ promotion: ChristmasPromotionView)
}

public struct ChristmasPromotionViewModel {
    let title: String
    let subtitle: String
    let buttonTitle: String
    
    public init(title: String, subtitle: String, buttonTitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.buttonTitle = buttonTitle
    }
}

public class ChristmasPromotionView: UIView {
    static let height: CGFloat = 150
    
    private lazy var backgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var smallShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.dropShadow(color: .shadowColor,
                        opacity: 0.24,
                        offset: CGSize(width: 0, height: 1),
                        radius: 1)
       
        return view
    }()
    
    private lazy var largeShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.dropShadow(color: .shadowColor,
                        opacity: 0.16,
                        offset: CGSize(width: 0, height: 1),
                        radius: 5)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var button: Button = {
        let button = Button(style: .default,size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImage(named: .christmasPromotion)
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.addArrangedSubviews([titleLabel, subtitleLabel, button])
        stack.setCustomSpacing(16, after: subtitleLabel)
        return stack
    }()
    
    public weak var delegate: PromotionViewDelegate?
    public var model: ChristmasPromotionViewModel {
        didSet {
            self.titleLabel.text = model.title
            self.subtitleLabel.text = model.subtitle
            self.button.setTitle(model.buttonTitle, for: .normal)
        }
    }
    
    public init (model: ChristmasPromotionViewModel) {
        self.model = model
        super.init(frame: .zero)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private functions
extension ChristmasPromotionView {
    private func setup() {
        addSubview(largeShadowView)
        largeShadowView.fillInSuperview()
        largeShadowView.addSubview(smallShadowView)
        smallShadowView.fillInSuperview()
        smallShadowView.addSubview(backgroundView)
        backgroundView.fillInSuperview()
        backgroundView.addSubview(verticalStack)
        backgroundView.addSubview(image)
        
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        button.setTitle(model.buttonTitle, for: .normal)
        
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .spacingM),
            verticalStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingL),
            verticalStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -.spacingL),
            verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: image.leadingAnchor, constant: .spacingS),
            image.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            image.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            image.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            image.widthAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    @objc private func buttonTapped() {
        delegate?.didSelectChristmasPromotion(self)
    }
}

//MARK: - Shadow Color
private extension UIColor {
    static var shadowColor: UIColor {
        return UIColor(hex: "475569")
    }
}
