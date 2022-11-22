import UIKit

public protocol BrazePromotionViewDelegate: AnyObject {
    func brazePromotionView(_ brazePromotionView: BrazePromotionView, didSelect action: BrazePromotionView.Action)
    func brazePromotionViewTapped(_ brazePromotionView: BrazePromotionView)
}

public class BrazePromotionView: UIView {
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
        let label = Label(style: .title3Strong, withAutoLayout: true)
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
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .bgPrimary
        button.setImage(UIImage(named: .cross), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.contentEdgeInsets = UIEdgeInsets(all: 6)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = button.frame.width / 2.0
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleTapOnCloseButton), for: .touchUpInside)
        return button
    }()

    private lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.image = UIImage(named: ImageAsset.noImage)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var imageContainer = UIView(withAutoLayout: true)

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS + .spacingXS, withAutoLayout: true)
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stackView
    }()

    private var viewModel: BrazePromotionViewModel
    private var imageDatasource: RemoteImageViewDataSource?

    // MARK: - Public properties

    public enum Action {
        case primary
        case secondary
    }

    public weak var delegate: BrazePromotionViewDelegate?

    // MARK: - Init

    public init(viewModel: BrazePromotionViewModel, imageDatasource: RemoteImageViewDataSource) {
        self.viewModel = viewModel
        self.imageDatasource = imageDatasource
        super.init(frame: .zero)
        setup()
        configure(with: viewModel, imageDatasource: imageDatasource)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides
    public override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.layer.cornerRadius = closeButton.bounds.width / 2.0
    }

    public func configure(with viewModel: BrazePromotionViewModel, imageDatasource datasource: RemoteImageViewDataSource) {
        titleLabel.text = viewModel.title
        primaryButton.configure(withTitle: viewModel.primaryButtonTitle)

        if let text = viewModel.text {
            textLabel.text = text
        } else {
            textLabel.isHidden = true
        }

        imageContainer.addSubview(remoteImageView)
        remoteImageView.dataSource = imageDatasource

        NSLayoutConstraint.activate([
            remoteImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            remoteImageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            remoteImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            remoteImageView.widthAnchor.constraint(lessThanOrEqualTo: remoteImageView.heightAnchor),
        ])
        loadImage()
        backgroundView.bringSubviewToFront(closeButton)
        layoutSubviews()
    }

    private func loadImage() {
        guard let imageUrl = viewModel.image else {
            imageContainer.removeFromSuperview()
            return
        }

        remoteImageView.loadImage(
            for: imageUrl,
            imageWidth: 130,
            fallbackImage: UIImage(named: .noImage)
        )
    }
}

// MARK: - Private functions
extension BrazePromotionView {
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
        backgroundView.addSubview(imageContainer)
        backgroundView.addSubview(closeButton)

        verticalStackView.addArrangedSubviews([titleLabel, textLabel, primaryButton])

        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            imageContainer.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            imageContainer.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: .spacingM),

            verticalStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingM),
            verticalStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .spacingM),
            verticalStackView.trailingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: -.spacingM),
            verticalStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -.spacingM),
            verticalStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),

            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
        ])
    }

    @objc private func primaryButtonTapped() {
        delegate?.brazePromotionView(self, didSelect: .primary)
    }

    @objc private func viewWasTapped() {
        delegate?.brazePromotionViewTapped(self)
    }

    @objc private func handleTapOnCloseButton() {
        delegate?.brazePromotionView(self, didSelect: .secondary)
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
