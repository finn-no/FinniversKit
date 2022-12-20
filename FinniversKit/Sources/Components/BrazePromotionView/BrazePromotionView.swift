import UIKit

public protocol BrazePromotionViewDelegate: AnyObject {
    func brazePromotionView(_ brazePromotionView: BrazePromotionView, didSelect action: BrazePromotionView.Action)
    func brazePromotionViewTapped(_ brazePromotionView: BrazePromotionView)
}

public class BrazePromotionView: UIView {

    private let buttonSize = 26.0

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
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.accessibilityTraits.insert(.header)
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var primaryButton: Button = {
        let button = Button(style: .callToAction, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()

    private lazy var closeButton: CloseButton = {
        let button = CloseButton(withAutoLayout: true)
        button.tintColor = .bgPrimary
        button.setImage(UIImage(named: .cross), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = buttonSize / 2.0
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(vertical: .spacingXS, horizontal: .spacingXS)
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

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS + .spacingXS, withAutoLayout: true)
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return stackView
    }()

    private lazy var stackViewConstraintsImage: [NSLayoutConstraint] = [
        verticalStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingM),
        verticalStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .spacingM),
        verticalStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -.spacingM),
        verticalStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
    ]

    private lazy var stackViewConstraintsNoImage: [NSLayoutConstraint] = [
        verticalStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingM),
        verticalStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .spacingM),
        verticalStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -.spacingM),
        verticalStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -.spacingM),
    ]

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

    public func configure(with viewModel: BrazePromotionViewModel, imageDatasource datasource: RemoteImageViewDataSource) {
        titleLabel.text = viewModel.title
        primaryButton.configure(withTitle: viewModel.primaryButtonTitle)

        if let text = viewModel.text {
            textLabel.text = text
        } else {
            textLabel.isHidden = true
        }

        loadImage()
        if let dismissible = viewModel.dismissible, !dismissible {
            closeButton.removeFromSuperview()
        } else {
            backgroundView.bringSubviewToFront(closeButton)
        }
    }

    private func loadImage() {
        guard let imageUrl = viewModel.image else {
            remoteImageView.removeFromSuperview()
            NSLayoutConstraint.deactivate(stackViewConstraintsImage)
            NSLayoutConstraint.activate(stackViewConstraintsNoImage)
            closeButton.setImage(UIImage(named: .cross).withTintColor(.textPrimary), for: .normal)
            closeButton.backgroundColor = UIColor.clear
            return
        }
        NSLayoutConstraint.deactivate(stackViewConstraintsNoImage)
        NSLayoutConstraint.activate(stackViewConstraintsImage)
        backgroundView.addSubview(remoteImageView)
        remoteImageView.dataSource = imageDatasource
        NSLayoutConstraint.activate([
            remoteImageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.3),
            remoteImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            remoteImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            remoteImageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
        remoteImageView.loadImage(
            for: imageUrl,
            imageWidth: 100,
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

        verticalStackView.addArrangedSubviews([titleLabel, textLabel, primaryButton])

        addSubview(largeShadowView)
        largeShadowView.addSubview(smallShadowView)
        smallShadowView.addSubview(backgroundView)
        backgroundView.addSubview(verticalStackView)
        backgroundView.addSubview(closeButton)

        largeShadowView.fillInSuperview()
        smallShadowView.fillInSuperview()
        backgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingS),
            closeButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -.spacingS),
            closeButton.widthAnchor.constraint(equalToConstant: buttonSize),
            closeButton.heightAnchor.constraint(equalToConstant: buttonSize)
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

private extension Button {
    func configure(withTitle title: String?) {
        if let title = title {
            setTitle(title, for: .normal)
        } else {
            isHidden = true
        }
    }
}

private class CloseButton: UIButton {
    // Spacing between button and top/trailing.
    var touchPointInset: CGFloat = 16

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -touchPointInset, dy: -touchPointInset).contains(point)
    }
}
