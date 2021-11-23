import UIKit

public protocol PromotionViewDelegate: AnyObject {
    func christmasPromotionView(_ promotionView: ChristmasPromotionView, didSelect action: ChristmasPromotionView.Action)
}

public struct ChristmasPromotionViewModel {
    
    let title: String
    let helpButtonTitle: String
    let adsButtonTitle: String
    
    public init(title: String, helpButtonTitle: String, adsButtonTitle: String) {
        self.title = title
        self.helpButtonTitle = helpButtonTitle
        self.adsButtonTitle = adsButtonTitle
    }
}

public class ChristmasPromotionView: UIView {
    static let height: CGFloat = 150
    public enum Action {
        case seeAds
        case help
    }
    
    private lazy var backgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgColor
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
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var helpButton: Button = {
        let button = Button(style: .default,size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(seeHelpButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.backgroundColor = .bgColor
        return button
    }()
    
    private lazy var seeAdsButton: Button = {
        let button = Button(style: .default, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(seeAdsButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.backgroundColor = .bgColor
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
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.addArrangedSubviews([titleLabel, helpButton, seeAdsButton])
        stack.setCustomSpacing(14, after: titleLabel)
        return stack
    }()
    
    public weak var delegate: PromotionViewDelegate?
    public var model: ChristmasPromotionViewModel {
        didSet {
            self.titleLabel.text = model.title
            self.helpButton.setTitle(model.helpButtonTitle, for: .normal)
            self.seeAdsButton.setTitle(model.adsButtonTitle, for: .normal)
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
        helpButton.setTitle(model.helpButtonTitle, for: .normal)
        seeAdsButton.setTitle(model.adsButtonTitle, for: .normal)
        
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .spacingM),
            verticalStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingL),
            verticalStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -(.spacingM + .spacingXXS)),
            verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: image.leadingAnchor, constant: .spacingXXL),
            image.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            image.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            image.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            image.widthAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    @objc private func seeAdsButtonTapped() {
        delegate?.christmasPromotionView(self, didSelect: .seeAds)
    }
    
    @objc private func seeHelpButtonTapped() {
        delegate?.christmasPromotionView(self, didSelect: .help)
    }
}

//MARK: - Shadow Color
private extension UIColor {
    static var shadowColor: UIColor {
        return UIColor(hex: "475569")
    }
    
    static var bgColor: UIColor {
        return .dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: .blueGray700)
    }
}
