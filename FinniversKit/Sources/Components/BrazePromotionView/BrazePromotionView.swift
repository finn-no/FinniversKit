import UIKit
import Warp

public protocol BrazePromotionViewDelegate: AnyObject {
    func brazePromotionView(_ brazePromotionView: BrazePromotionView, didSelect action: BrazePromotionView.Action)
    func brazePromotionViewTapped(_ brazePromotionView: BrazePromotionView)
}

public class BrazePromotionView: UIView {

    private let buttonSize = 26.0

    public enum ImagePosition {
        case left
        case right
        case top
    }

    private lazy var backgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
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

    private lazy var borderlessButton: Button = {
        let button = Button(style: .link, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(borderlessButtonTapped), for: .touchUpInside)
        button.setContentHuggingPriority(.required, for: .vertical)
        return button
    }()

    private lazy var closeButton: CloseButton = {
        let button = CloseButton(withAutoLayout: true)
        button.tintColor = .background
        button.setImage(UIImage(named: .cross), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = buttonSize / 2.0
        button.clipsToBounds = true
        button.imageEdgeInsets = UIEdgeInsets(vertical: Warp.Spacing.spacing50, horizontal: Warp.Spacing.spacing50)
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
        let stackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing100, withAutoLayout: true)
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Warp.Spacing.spacing100)
        return stackView
    }()

    private func determineButtonStackViewAxis() -> NSLayoutConstraint.Axis {
        if viewModel.buttonOrientation == .horizontal || UITraitCollection.current.horizontalSizeClass == .regular {
            return .horizontal
        } else {
            return .vertical
        }
    }

    private lazy var buttonStackView: UIStackView = {
        let axis = determineButtonStackViewAxis()
        let spacing: CGFloat = axis == .horizontal ? Warp.Spacing.spacing200 : Warp.Spacing.spacing50
        let stackView = UIStackView(axis: axis, spacing: spacing, withAutoLayout: true)
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.addArrangedSubview(primaryButton)
        stackView.addArrangedSubview(borderlessButton)
        return stackView
    }()

    private var stackViewConstraintsImage: [NSLayoutConstraint] = []

    private lazy var stackViewConstraintsNoImage: [NSLayoutConstraint] = [
        verticalStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Warp.Spacing.spacing200),
        verticalStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Warp.Spacing.spacing200),
        verticalStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Warp.Spacing.spacing200),
        verticalStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -Warp.Spacing.spacing200),
    ]

    private var viewModel: BrazePromotionViewModel
    private var imageDatasource: RemoteImageViewDataSource?
    private var imagePosition: ImagePosition

    // MARK: - Public properties

    public enum Action {
        case primary
        case secondary
        case borderless
    }

    public enum ButtonOrientation: String, Sendable {
        case horizontal = "horizontal"
        case vertical = "vertical"
    }

    public enum BackgroundColor: String, Sendable {
        case elevatedSurfaceColor = "elevatedSurfaceColor"
        case subtleBackgroundColor = "subtleBackgroundColor"
        case primaryBackgroundColor = "primaryBackgroundColor"
        case positiveBackgroundColor = "positiveBackgroundColor"
        case warningBackgroundColor = "warningBackgroundColor"
    }

    public enum CardStyle: String, Sendable {
        case leftAlignedGraphic = "leftAlignedGraphic"
        case rightAlignedGraphic = "rightAlignedGraphic"
        case topAlignedGraphic = "topAlignedGraphic"
    }

    public weak var delegate: BrazePromotionViewDelegate?

    // MARK: - Init

    public init(viewModel: BrazePromotionViewModel, imageDatasource: RemoteImageViewDataSource) {
        self.viewModel = viewModel
        self.imageDatasource = imageDatasource
        self.imagePosition = .right // default value
        super.init(frame: .zero)
        determineBackgroundColor()
        determineImagePosition()
        setup()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func determineBackgroundColor() {
        switch viewModel.backgroundColor {
        case .elevatedSurfaceColor:
            backgroundView.backgroundColor = .surfaceElevated200
        case .subtleBackgroundColor:
            backgroundView.backgroundColor = .backgroundSubtle
        case .primaryBackgroundColor:
            backgroundView.backgroundColor = .backgroundPrimarySubtle
        case .positiveBackgroundColor:
            backgroundView.backgroundColor = .backgroundPositiveSubtle
        case .warningBackgroundColor:
            backgroundView.backgroundColor = .backgroundWarningSubtle
        }
    }

    private func determineImagePosition() {
        switch viewModel.style {
        case .rightAlignedGraphic:
            imagePosition = .right
        case .leftAlignedGraphic:
            imagePosition = .left
        case .topAlignedGraphic:
            imagePosition = .top
        }
    }

    private func configure() {
        titleLabel.text = viewModel.title
        primaryButton.configure(withTitle: viewModel.primaryButtonTitle)
        borderlessButton.configure(withTitle: viewModel.borderlessButtonTitle)

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
        if let imageUrl = viewModel.image {
            closeButton.setImage(UIImage(named: .cross), for: .normal)
            closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)

            backgroundView.addSubview(remoteImageView)
            remoteImageView.dataSource = imageDatasource

            var imageConstraints: [NSLayoutConstraint] = []

            switch imagePosition {
            case .left:
                stackViewConstraintsImage = [
                    verticalStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Warp.Spacing.spacing200),
                    verticalStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -Warp.Spacing.spacing200),
                    verticalStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Warp.Spacing.spacing200),
                    verticalStackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: Warp.Spacing.spacing200),
                    verticalStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
                ]

                imageConstraints = [
                    remoteImageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.3),
                    remoteImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                    remoteImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
                    remoteImageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
                ]

            case .right:
                stackViewConstraintsImage = [
                    verticalStackView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Warp.Spacing.spacing200),
                    verticalStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Warp.Spacing.spacing200),
                    verticalStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Warp.Spacing.spacing200),
                    verticalStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
                ]

                imageConstraints = [
                    remoteImageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.3),
                    remoteImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                    remoteImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
                    remoteImageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
                ]

            case .top:
                stackViewConstraintsImage = [
                    verticalStackView.topAnchor.constraint(equalTo: remoteImageView.bottomAnchor, constant: Warp.Spacing.spacing200),
                    verticalStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Warp.Spacing.spacing200),
                    verticalStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -Warp.Spacing.spacing200),
                    verticalStackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Warp.Spacing.spacing200)
                ]

                imageConstraints = [
                    remoteImageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor),
                    remoteImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
                    remoteImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
                    remoteImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
                    remoteImageView.heightAnchor.constraint(equalTo: remoteImageView.widthAnchor, multiplier: 0.5)
                ]
            }

            NSLayoutConstraint.activate(stackViewConstraintsImage + imageConstraints)

            remoteImageView.loadImage(
                for: imageUrl,
                imageWidth: 100,
                fallbackImage: UIImage(named: .noImage)
            )
        } else {
            closeButton.setImage(UIImage(named: .cross).withTintColor(.text), for: .normal)
            closeButton.backgroundColor = UIColor.clear

            buttonStackView.axis = .horizontal
            NSLayoutConstraint.activate(stackViewConstraintsNoImage)
        }
    }
}

// MARK: - Private functions
extension BrazePromotionView {
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewWasTapped))
        addGestureRecognizer(tapGesture)

        verticalStackView.addArrangedSubviews([titleLabel, textLabel, buttonStackView])
        verticalStackView.setCustomSpacing(Warp.Spacing.spacing100 + Warp.Spacing.spacing50, after: textLabel)

        addSubview(largeShadowView)
        largeShadowView.addSubview(smallShadowView)
        smallShadowView.addSubview(backgroundView)
        backgroundView.addSubview(verticalStackView)
        backgroundView.addSubview(closeButton)

        largeShadowView.fillInSuperview()
        smallShadowView.fillInSuperview()
        backgroundView.fillInSuperview()

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Warp.Spacing.spacing100),
            closeButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -Warp.Spacing.spacing100),
            closeButton.widthAnchor.constraint(equalToConstant: buttonSize),
            closeButton.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
    }

    @objc private func primaryButtonTapped() {
        delegate?.brazePromotionView(self, didSelect: .primary)
    }

    @objc private func borderlessButtonTapped() {
        delegate?.brazePromotionView(self, didSelect: .borderless)
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
        return .black
    }

    static var bgColor: UIColor {
        return .background
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
