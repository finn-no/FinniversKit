import Foundation
import UIKit

public protocol TransactionEntryViewModel {
    var title: String { get }
    var text: String { get }
    var imageUrl: String? { get }
    var showWarningIcon: Bool { get }
    var fallbackImage: UIImage { get }
}

public protocol TransactionEntryViewDelegate: AnyObject {
    
}

public class TransactionEntryView: UIView {

    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .bgSecondary
        imageView.layer.cornerRadius = .spacingS
        imageView.layer.masksToBounds = true
        imageView.delegate = self
        return imageView
    }()

    private lazy var processIllustrationView: UIView = {
        let view = ProcessIllustrationView(color: .btnPrimary)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var navigationLinkView: NavigationLinkView = {
        let view = NavigationLinkView(withSubview: contentView, withAutoLayout: true, padding: .spacingM, backgroundColor: .bgTertiary)
        return view
    }()

    private let spacing: CGFloat = .spacingXS + .spacingS
    private let imageWidth: CGFloat = 32
    private var fallbackImage: UIImage?

    public init(delegate: TransactionEntryViewDelegate?, remoteImageViewDataSource: RemoteImageViewDataSource?) {
        super.init(frame: .zero)
        imageView.dataSource = remoteImageViewDataSource
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(navigationLinkView)
        navigationLinkView.fillInSuperview()

        let textContainer = UIView(withAutoLayout: true)

        contentView.addSubview(imageView)
        contentView.addSubview(processIllustrationView)
        contentView.addSubview(textContainer)

        textContainer.addSubview(titleLabel)
        textContainer.addSubview(textLabel)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            processIllustrationView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            processIllustrationView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: spacing),
            processIllustrationView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            textContainer.leadingAnchor.constraint(equalTo: processIllustrationView.trailingAnchor, constant: spacing),
            textContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            textContainer.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            textContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: textContainer.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),

            textLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            textLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor),
        ])
    }

    public func configure(with viewModel: TransactionEntryViewModel) {
        titleLabel.text = viewModel.title
        textLabel.text = viewModel.text
        self.fallbackImage = viewModel.fallbackImage

        if let imageUrl = viewModel.imageUrl {
            imageView.loadImage(for: imageUrl, imageWidth: imageWidth, loadingColor: .bgSecondary)
        } else {
            setFallbackImage()
        }
    }

    private func setFallbackImage() {
        imageView.image = fallbackImage
        imageView.contentMode = .scaleAspectFit
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
