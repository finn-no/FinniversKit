import Foundation
import UIKit

public protocol TransactionEntryViewDelegate: AnyObject {
    func transactionEntryViewWasTapped(_ transactionEntryView: TransactionEntryView)
}

public class TransactionEntryView: UIView {

    // MARK: - Public properties

    public weak var delegate: TransactionEntryViewDelegate?

    public weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = remoteImageViewDataSource
        }
    }

    // MARK: - Private properties

    private let imageSize: CGFloat = 32
    private let navigationLinkBackgroundColor: UIColor
    private var fallbackImage: UIImage?
    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var transactionStepView = TransactionStepView(withAutoLayout: true)

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.backgroundColor = .bgSecondary
        imageView.layer.cornerRadius = .spacingS
        imageView.layer.masksToBounds = true
        imageView.delegate = self
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
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

        contentView.addSubview(imageView)
        contentView.addSubview(transactionStepView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),

            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            transactionStepView.topAnchor.constraint(equalTo: contentView.topAnchor),
            transactionStepView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .spacingXS + .spacingS),
            transactionStepView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            transactionStepView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: TransactionEntryViewModel) {
        transactionStepView.configure(
            withTitle: viewModel.title,
            text: viewModel.text,
            showWarningIcon: viewModel.showWarningIcon
        )

        self.fallbackImage = viewModel.fallbackImage
        navigationLinkView.setAccessibilityLabel(viewModel.accessibilityLabel)

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
