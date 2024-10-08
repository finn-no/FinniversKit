import UIKit
import Warp

public protocol PromotionViewDelegate: AnyObject {
    func promotionView(_ promotionView: PromotionView, didSelect action: PromotionView.Action)
    func promotionViewTapped(_ promotionView: PromotionView)
}

public class PromotionView: UIView {
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
        let label = Label(style: .title3, withAutoLayout: true)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.accessibilityTraits.insert(.header)
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
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()

    private lazy var secondaryButton: Button = {
        let button = Button(style: .customStyle, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var imageContainer = UIView(withAutoLayout: true)

    private lazy var backgroundImageContainer = UIView(withAutoLayout: true)

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing100 + Warp.Spacing.spacing50, withAutoLayout: true)
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var compactDynamicConstraints: [NSLayoutConstraint] = [
        imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -Warp.Spacing.spacing800),
        imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: backgroundImageContainer.leadingAnchor, constant: Warp.Spacing.spacing200),
        imageView.widthAnchor.constraint(lessThanOrEqualTo: imageView.heightAnchor, multiplier: viewModel.imageRatio),
    ]
    private lazy var regularDynamicConstraint: [NSLayoutConstraint] = [
        imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
        imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
        imageView.leadingAnchor.constraint(equalTo: backgroundImageContainer.leadingAnchor, constant: Warp.Spacing.spacing200),
        imageView.widthAnchor.constraint(lessThanOrEqualTo: imageView.heightAnchor, multiplier: viewModel.imageRatio),
    ]
    private var viewModel: PromotionViewModel

    // MARK: - Public properties

    public enum Action {
        case primary
        case secondary
    }

    public weak var delegate: PromotionViewDelegate?

    // MARK: - Init

    public init(viewModel: PromotionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
        configure(with: viewModel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: PromotionViewModel) {
        titleLabel.text = viewModel.title
        primaryButton.configure(withTitle: viewModel.primaryButtonTitle)
        secondaryButton.configure(withTitle: viewModel.secondaryButtonTitle)

        if let text = viewModel.text {
            textLabel.text = text
        } else {
            textLabel.isHidden = true
        }

        if let backgroundImage = viewModel.backgroundImage {
            backgroundImageContainer.addSubview(backgroundImageView)
            backgroundImageView.image = backgroundImage
            backgroundImageView.fillInSuperview()
        }

        imageContainer.addSubview(imageView)
        imageView.image = viewModel.image

        switch viewModel.imageAlignment {
        case .fullWidth:
            imageView.fillInSuperview(insets: UIEdgeInsets(top: Warp.Spacing.spacing200, leading: Warp.Spacing.spacing100, bottom: -Warp.Spacing.spacing200, trailing: -Warp.Spacing.spacing100))
        case .trailing:
            let imageRatio = viewModel.imageRatio
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
                imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
                imageView.widthAnchor.constraint(lessThanOrEqualTo: imageView.heightAnchor, multiplier: imageRatio),
            ])
        case .dynamic:
            if UITraitCollection.isHorizontalSizeClassRegular {
                activateRegularConstraints()
            } else {
                activateCompactConstraints()
            }
        }

        if let imageBackgroundColor = viewModel.imageBackgroundColor {
            imageContainer.backgroundColor = imageBackgroundColor
        }
    }

    private func activateCompactConstraints() {
        NSLayoutConstraint.deactivate(regularDynamicConstraint)
        NSLayoutConstraint.activate(compactDynamicConstraints)
    }

    private func activateRegularConstraints() {
        NSLayoutConstraint.deactivate(compactDynamicConstraints)
        NSLayoutConstraint.activate(regularDynamicConstraint)
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            if UITraitCollection.isHorizontalSizeClassRegular {
                activateRegularConstraints()
            } else {
                activateCompactConstraints()
            }
        }
    }

    private func isCompactScreen() -> Bool {
        return traitCollection.horizontalSizeClass == .compact
    }
}

// MARK: - Private functions
extension PromotionView {
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        addGestureRecognizer(tapGesture)

        addSubview(largeShadowView)
        largeShadowView.fillInSuperview()
        largeShadowView.addSubview(smallShadowView)
        smallShadowView.fillInSuperview()
        smallShadowView.addSubview(backgroundView)
        backgroundView.fillInSuperview()
        backgroundView.addSubview(verticalStackView)
        backgroundView.addSubview(backgroundImageContainer)
        backgroundView.addSubview(imageContainer)

        verticalStackView.addArrangedSubviews([titleLabel, textLabel, primaryButton, secondaryButton])

        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),

            backgroundImageContainer.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            backgroundImageContainer.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            backgroundImageContainer.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            backgroundImageContainer.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.3),

            verticalStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Warp.Spacing.spacing200),
            verticalStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Warp.Spacing.spacing200),
            verticalStackView.trailingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: -Warp.Spacing.spacing200),
            verticalStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Warp.Spacing.spacing200),
            verticalStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6)
        ])
    }

    @objc private func primaryButtonTapped() {
        delegate?.promotionView(self, didSelect: .primary)
    }

    @objc private func secondaryButtonTapped() {
        delegate?.promotionView(self, didSelect: .secondary)
    }

    @objc private func viewWasTapped() {
        delegate?.promotionViewTapped(self)
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var shadowColor: UIColor {
        return .black
    }

    static var bgColor: UIColor {
        return .surfaceElevated200
    }
}

private extension Button.Style {
    static var customStyle = Button.Style.default.overrideStyle(bodyColor: .bgColor, highlightedBodyColor: .backgroundInfoSubtle)
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
