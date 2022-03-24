import UIKit

public protocol PromotionViewDelegate: AnyObject {
    func promotionView(_ promotionView: PromotionView, didSelect action: PromotionView.Action)
}

public struct PromotionViewModel {
    let title: String
    let text: String?
    let image: UIImage
    let imageAlignment: ImageAlignment
    let imageBackgroundColor: UIColor?
    let primaryButtonTitle: String?
    let secondaryButtonTitle: String?

    /// Image's alignment inside image container. The full image will always be visible.
    public enum ImageAlignment {
        case trailing
        case centered
    }

    public init(
        title: String,
        text: String? = nil,
        image: UIImage,
        imageAlignment: ImageAlignment,
        imageBackgroundColor: UIColor? = nil,
        primaryButtonTitle: String? = nil,
        secondaryButtonTitle: String? = nil
    ) {
        self.title = title
        self.text = text
        self.image = image
        self.imageAlignment = imageAlignment
        self.imageBackgroundColor = imageBackgroundColor
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}

public class PromotionView: UIView {
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
        view.dropShadow(
            color: .shadowColor,
            opacity: 0.24,
            offset: CGSize(width: 0, height: 1),
            radius: 1
        )
        return view
    }()

    private lazy var largeShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.dropShadow(
            color: .shadowColor,
            opacity: 0.16,
            offset: CGSize(width: 0, height: 1),
            radius: 5
        )
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var primaryButton: Button = {
        let button = Button(style: .customStyle, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()

    private lazy var secondaryButton: Button = {
        let button = Button(style: .customStyle, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var imageContainer = UIView(withAutoLayout: true)

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.spacing = .spacingS + .spacingXS
        stack.distribution = .fillProportionally
        stack.setContentCompressionResistancePriority(.required, for: .horizontal)
        stack.alignment = .leading
        return stack
    }()

    public weak var delegate: PromotionViewDelegate?

    public init(model: PromotionViewModel) {
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
        imageView.contentMode = .scaleAspectFit

        if let text = viewModel.text {
            textLabel.text = text
        } else {
            textLabel.isHidden = true
        }

        primaryButton.configure(withTitle: viewModel.primaryButtonTitle)
        secondaryButton.configure(withTitle: viewModel.secondaryButtonTitle)

        switch viewModel.imageAlignment {
        case .trailing:
            let imageRatio = viewModel.image.size.width / viewModel.image.size.height
            imageContainer.addSubview(imageView)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
                imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: imageRatio)
            ])

        case .centered:
            imageContainer.backgroundColor = backgroundColor
            imageContainer.addSubview(imageView)
            imageView.fillInSuperview(insets: UIEdgeInsets(top: .spacingM, leading: .spacingS, bottom: -.spacingM, trailing: -.spacingS))
        }

        if let imageBackgroundColor = viewModel.imageBackgroundColor {
            imageContainer.backgroundColor = imageBackgroundColor
        }
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
        backgroundView.addSubview(imageContainer)

        verticalStack.addArrangedSubviews([titleLabel, textLabel, primaryButton, secondaryButton])

        imageContainer.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        verticalStack.setContentHuggingPriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            imageContainer.heightAnchor.constraint(equalTo: backgroundView.heightAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .spacingM),
            verticalStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingM),
            verticalStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -.spacingM),
            verticalStack.trailingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: -.spacingM),
            verticalStack.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
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
