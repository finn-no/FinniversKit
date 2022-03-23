import UIKit

public protocol PromotionViewDelegate: AnyObject {
    func promotionView(_ promotionView: PromotionView, didSelect action: PromotionView.Action)
}

public struct PromotionViewModel {
    let title: String
    let image: UIImage
    let primaryButtonTitle: String?
    let secondaryButtonTitle: String?

    public init(title: String, image: UIImage, primaryButtonTitle: String? = nil, secondaryButtonTitle: String? = nil) {
        self.title = title
        self.image = image
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}

public class PromotionView: UIView {
    static let height: CGFloat = 150

    public enum Action {
        case primary
        case secondary
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

    private lazy var primaryButton: Button = {
        let button = Button(style: .customStyle, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: .spacingXL).isActive = true
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }()

    private lazy var secondaryButton: Button = {
        let button = Button(style: .customStyle, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: .spacingXL).isActive = true
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.spacing = .spacingXS + .spacingS
        stack.distribution = .fillProportionally
        stack.setContentCompressionResistancePriority(.required, for: .horizontal)
        stack.alignment = .leading
        return stack
    }()

    public weak var delegate: PromotionViewDelegate?

    public init (model: PromotionViewModel) {
        super.init(frame: .zero)
        setup()
        configure(with: model)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: PromotionViewModel) {
        titleLabel.text = viewModel.title
        imageView.image = viewModel.image
        primaryButton.configure(withTitle: viewModel.primaryButtonTitle)
        secondaryButton.configure(withTitle: viewModel.secondaryButtonTitle)
    }
}

// MARK: - Private functions
extension PromotionView {
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(largeShadowView)
        largeShadowView.fillInSuperview()
        largeShadowView.addSubview(smallShadowView)
        smallShadowView.fillInSuperview()
        smallShadowView.addSubview(backgroundView)
        backgroundView.fillInSuperview()
        backgroundView.addSubview(verticalStack)
        backgroundView.addSubview(imageView)

        verticalStack.addArrangedSubviews([titleLabel, primaryButton, secondaryButton])
        verticalStack.setCustomSpacing(.spacingM, after: titleLabel)

        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: verticalStack.trailingAnchor, constant: .spacingM),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            verticalStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .spacingM),
            verticalStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingL),
            verticalStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -(.spacingM + .spacingXXS)),
            verticalStack.widthAnchor.constraint(equalToConstant: 150),
        ])
    }

    @objc private func primaryButtonTapped() {
        delegate?.promotionView(self, didSelect: .primary)
    }

    @objc private func secondaryButtonTapped() {
        delegate?.promotionView(self, didSelect: .secondary)
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var shadowColor: UIColor {
        return UIColor(hex: "475569")
    }

    static var bgColor: UIColor {
        return .dynamicColor(defaultColor: .milk, darkModeColor: .blueGray700)
    }
}

private extension Button.Style {
    static var customStyle = Button.Style.default.overrideStyle(bodyColor: .bgColor, highlightedBodyColor: .bgSecondary)
}

private extension Button {
    func configure(withTitle title: String?) {
        if let title = title {
            setTitle(title, for: .normal)
        } else {
            isHidden = true
        }
    }
}
