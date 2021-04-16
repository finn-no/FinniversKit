import Foundation
import UIKit

public protocol TransactionEntryViewModel {
    var title: String { get }
    var text: String { get }
    var imageUrl: String? { get }
    var showWarningIcon: Bool { get }
    var fallbackImage: UIImage { get }
    var accessibilityLabel: String { get }
}

public protocol TransactionEntryViewDelegate: AnyObject {
    func transactionEntryViewWasTapped(_ transactionEntryView: TransactionEntryView)
}

public class TransactionEntryView: UIView {

    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.backgroundColor = .bgSecondary
        imageView.layer.cornerRadius = .spacingS
        imageView.layer.masksToBounds = true
        imageView.delegate = self
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private lazy var warningIconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .warning)
        return imageView
    }()

    private lazy var processIllustrationView: UIView = {
        let view = TransactionStepIllustrationView(color: .btnPrimary)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 2
        return label
    }()

    private lazy var navigationLinkView: NavigationLinkView = {
        let view = NavigationLinkView(
            withSubview: contentView,
            withAutoLayout: true,
            padding: .spacingXS + .spacingS,
            backgroundColor: navigationLinkBackgroundColor
        )
        view.delegate = self
        return view
    }()

    private let imageSize: CGFloat = 32
    private var fallbackImage: UIImage?
    private let navigationLinkBackgroundColor: UIColor

    public weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = remoteImageViewDataSource
        }
    }

    public weak var delegate: TransactionEntryViewDelegate?

    // MARK: - Init

    public init(
        backgroundColor: UIColor = .bgTertiary,
        withAutoLayout: Bool = false
    ) {
        self.navigationLinkBackgroundColor = backgroundColor
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(navigationLinkView)
        navigationLinkView.fillInSuperview()

        let textContainer = UIView(withAutoLayout: true)

        contentView.addSubview(imageView)
        contentView.addSubview(processIllustrationView)
        contentView.addSubview(textContainer)

        textContainer.addSubview(titleLabel)
        textContainer.addSubview(textLabel)
        textContainer.addSubview(warningIconImageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),

            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            processIllustrationView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingXXS),
            processIllustrationView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .spacingXS + .spacingS),
            processIllustrationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            textContainer.leadingAnchor.constraint(equalTo: processIllustrationView.trailingAnchor, constant: .spacingS),
            textContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            textContainer.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            textContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: textContainer.topAnchor),

            warningIconImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .spacingS),
            warningIconImageView.topAnchor.constraint(equalTo: textContainer.topAnchor),
            warningIconImageView.trailingAnchor.constraint(lessThanOrEqualTo: textContainer.trailingAnchor),

            textLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
            textLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor),
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: TransactionEntryViewModel) {
        titleLabel.text = viewModel.title
        textLabel.text = viewModel.text
        self.fallbackImage = viewModel.fallbackImage
        navigationLinkView.setAccessibilityLabel(viewModel.accessibilityLabel)

        warningIconImageView.isHidden = !viewModel.showWarningIcon

        if let imageUrl = viewModel.imageUrl {
            imageView.contentMode = .scaleAspectFill
            imageView.loadImage(for: imageUrl, imageWidth: imageSize, loadingColor: .bgSecondary)
        } else {
            setFallbackImage()
        }
    }

    // MARK: - Private methods

    private func setFallbackImage() {
        imageView.image = fallbackImage
        imageView.contentMode = .scaleAspectFit
    }
}

// MARK: - NavigationLinkViewDelegate

extension TransactionEntryView: NavigationLinkViewDelegate {
    public func navigationLinkViewWasTapped(_ navigationLinkView: NavigationLinkView) {
        delegate?.transactionEntryViewWasTapped(self)
    }
}

// MARK: - RemoteImageViewDelegate

extension TransactionEntryView: RemoteImageViewDelegate {
    public func remoteImageViewDidSetImage(_ view: RemoteImageView) {
        if imageView.image == nil {
            setFallbackImage()
        }
    }
}
