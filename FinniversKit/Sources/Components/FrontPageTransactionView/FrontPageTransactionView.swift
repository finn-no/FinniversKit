import UIKit

public protocol FrontPageTransactionViewDelegate: AnyObject {
    func transactionViewTapped(_ transactionView: FrontPageTransactionView)
}

public class FrontPageTransactionView: UIStackView {
    public weak var delegate: FrontPageTransactionViewDelegate?

    private let imageWidth: CGFloat = 56
    private let cornerRadius: CGFloat = 8

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.image = UIImage(named: ImageAsset.noImage)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var contentTextStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = .spacingXS
        return stack
    }()

    private lazy var backgroundContainer: UIStackView = {
        let view = UIStackView(axis: .horizontal, withAutoLayout: true)
        view.alignment = .center
        view.distribution = .fill
        view.backgroundColor = .bgColor
        view.layer.cornerRadius = cornerRadius
        return view
    }()

    private lazy var imageContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgColor
        return view
    }()

    private lazy var smallShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgColor
        view.dropShadow(
            color: .shadowColor,
            opacity: 0.24,
            offset: CGSize(width: 0, height: 1),
            radius: 1
        )
        view.layer.cornerRadius = cornerRadius
        return view
    }()

    private lazy var largeShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgColor
        view.dropShadow(
            color: .shadowColor,
            opacity: 0.16,
            offset: CGSize(width: 0, height: 1),
            radius: 5
        )
        view.layer.cornerRadius = cornerRadius
        return view
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .fill
        stack.spacing = .spacingM
        return stack
    }()

    private lazy var headerLabel: UILabel = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.accessibilityTraits.insert(.header)
        label.numberOfLines = 0
        return label
    }()

    public private(set) var viewModel: FrontPageTransactionViewModel?

    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

// MARK: - Private functions

extension FrontPageTransactionView {
    private func setup() {
        axis = .vertical
        distribution = .fillProportionally
        spacing = .spacingS

        var constraints: [NSLayoutConstraint] = []

        backgroundContainer.isLayoutMarginsRelativeArrangement = true
        backgroundContainer.layoutMargins = .init(all: .spacingM)

        addArrangedSubviews([headerLabel, backgroundContainer])
        insertSubview(smallShadowView, belowSubview: backgroundContainer)
        insertSubview(largeShadowView, belowSubview: smallShadowView)
        constraints += [
            smallShadowView.widthAnchor.constraint(equalTo: backgroundContainer.widthAnchor),
            smallShadowView.heightAnchor.constraint(equalTo: backgroundContainer.heightAnchor),
            smallShadowView.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
            smallShadowView.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor),
            largeShadowView.widthAnchor.constraint(equalTo: backgroundContainer.widthAnchor),
            largeShadowView.heightAnchor.constraint(equalTo: backgroundContainer.heightAnchor),
            largeShadowView.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
            largeShadowView.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor)
        ]

        contentTextStack.addArrangedSubviews([titleLabel, subtitleLabel])

        imageContainerView.addSubview(imageView)
        constraints += [
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageWidth),
            imageView.heightAnchor.constraint(equalToConstant: imageWidth),
            imageContainerView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            imageContainerView.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor)
        ]

        contentStack.addArrangedSubviews([contentTextStack, imageContainerView])

        backgroundContainer.addArrangedSubview(contentStack)

        NSLayoutConstraint.activate(constraints)

        backgroundContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }

    private func loadImage() {
        guard let model = viewModel, let imageUrl = model.imageUrl else {
            imageView.setImage(UIImage(named: ImageAsset.noImage), animated: false)
            return
        }

        imageView.loadImage(
            for: imageUrl,
            imageWidth: imageWidth,
            fallbackImage: UIImage(named: ImageAsset.noImage)
        )
    }

    @objc private func viewTapped() {
        delegate?.transactionViewTapped(self)
    }
}

// MARK: - Public API
extension FrontPageTransactionView {
    public func configure(
        with model: FrontPageTransactionViewModel,
        andImageDatasource datasource: RemoteImageViewDataSource
    ) {
        self.viewModel = model
        imageView.dataSource = datasource
        headerLabel.text = model.headerTitle
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        loadImage()
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var shadowColor: UIColor {
        return UIColor(hex: "475569")
    }

    static var bgColor: UIColor {
        return .dynamicColor(defaultColor: .white, darkModeColor: .darkBgPrimaryProminent)
    }
}

