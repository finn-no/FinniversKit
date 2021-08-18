import Foundation
import UIKit

public protocol BasicPromoSlideViewDelegate: AnyObject {
    func basicPromoSlideViewDidTapButton(_ basicPromoSlideView: BasicPromoSlideView, promoIdentifier: String)
}

public class BasicPromoSlideView: UIView {
    private lazy var titleLabel: Label = {
        let label = Label(style: titleStyle, withAutoLayout: true)
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()

    private lazy var button: Button = {
        let style = Button.Style.default.overrideStyle(
            bodyColor: .primaryBlue,
            borderColor: .white,
            textColor: .white,
            highlightedBodyColor: .primaryBlue,
            highlightedBorderColor: UIColor.white.withAlphaComponent(0.8),
            highlightedTextColor: UIColor.white.withAlphaComponent(0.8)
        )
        let button = Button(style: style, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var imageViewTrailingAnchorContraint = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)

    private let promoIdentifier: String
    private let titleStyle: Label.Style

    public weak var delegate: BasicPromoSlideViewDelegate?
    public weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = remoteImageViewDataSource
        }
    }

    // MARK: - Init

    public init(titleStyle: Label.Style = .title3Strong, promoIdentifier: String) {
        self.titleStyle = titleStyle
        self.promoIdentifier = promoIdentifier
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingS + .spacingXS, withAutoLayout: true)
        stackView.addArrangedSubviews([titleLabel, button])
        stackView.alignment = .leading

        addSubview(imageView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: imageView.leadingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageViewTrailingAnchorContraint,
        ])
    }

    // MARK: - Public methods

    public func configure(
        with text: String,
        buttonTitle: String,
        image: UIImage?,
        imageUrl: String? = nil,
        scaleImageToFit: Bool = false
    ) {
        titleLabel.text = text
        button.setTitle(buttonTitle, for: .normal)
        imageView.image = image

        let imageSize: CGFloat = 130

        if let imageUrl = imageUrl {
            imageView.loadImage(for: imageUrl, imageWidth: imageSize)
        }

        if scaleImageToFit {
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: heightAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
            imageView.contentMode = .scaleAspectFill
            imageViewTrailingAnchorContraint.constant = -.spacingM
        }
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.basicPromoSlideViewDidTapButton(self, promoIdentifier: promoIdentifier)
    }
}
