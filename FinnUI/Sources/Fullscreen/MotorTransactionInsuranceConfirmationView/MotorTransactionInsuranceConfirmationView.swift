import FinniversKit

public protocol MotorTransactionInsuranceConfirmationViewModel {
    var logoImageUrl: String? { get }
    var companyName: String { get }
    var bodyText: String { get }
    var confirmationDetails: [KeyValuePair] { get }
    var caption: String { get }
    var buttonTitle: String { get }
}

// swiftlint:disable:next type_name
public class MotorTransactionInsuranceConfirmationView: ShadowScrollView {

    private lazy var companyNameLabel = Label(style: .bodyStrong, withAutoLayout: true)
    private let logoImageWidth: CGFloat = 30

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.dataSource = remoteImageViewDataSource
        imageView.layer.cornerRadius = logoImageWidth/2
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var captionLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var keyValueGridContainer: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgSecondary
        view.layer.cornerRadius = .spacingS
        return view
    }()

    private lazy var keyValueGrid: KeyValueGridView = {
        let view = KeyValueGridView(withAutoLayout: true)
        view.numberOfColumns = isHorizontalSizeClassRegular ? 2 : 1
        view.backgroundColor = .bgSecondary
        view.layer.cornerRadius = .spacingS
        return view
    }()

    private lazy var confirmationButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.delegate = self
        return scrollView
    }()

    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    // MARK: - Init

    public init(
        viewModel: MotorTransactionInsuranceConfirmationViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        setup()
        configure(with: viewModel)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        insertSubview(scrollView, belowSubview: topShadowView)
        scrollView.fillInSuperview()

        let contentView = UIView(withAutoLayout: true)
        scrollView.addSubview(contentView)
        contentView.fillInSuperview()

        let companyStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        companyStackView.addArrangedSubviews([logoImageView, companyNameLabel])

        contentView.addSubview(companyStackView)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(keyValueGridContainer)
        contentView.addSubview(captionLabel)
        contentView.addSubview(confirmationButton)

        keyValueGridContainer.addSubview(keyValueGrid)
        keyValueGrid.fillInSuperview(margin: .spacingM)

        let margin: CGFloat = .spacingM

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            topShadowView.bottomAnchor.constraint(equalTo: topAnchor),

            companyStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            companyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            companyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            bodyLabel.topAnchor.constraint(equalTo: companyStackView.bottomAnchor, constant: .spacingM),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            keyValueGridContainer.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: .spacingM),
            keyValueGridContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            keyValueGridContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            captionLabel.topAnchor.constraint(equalTo: keyValueGridContainer.bottomAnchor, constant: .spacingM),
            captionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            captionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            confirmationButton.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: .spacingM),
            confirmationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            confirmationButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            confirmationButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),

            logoImageView.widthAnchor.constraint(equalToConstant: logoImageWidth),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),

        ])
    }

    private func configure(with viewModel: MotorTransactionInsuranceConfirmationViewModel) {
        companyNameLabel.text = viewModel.companyName
        bodyLabel.text = viewModel.bodyText
        captionLabel.text = viewModel.caption

        keyValueGrid.configure(with: viewModel.confirmationDetails, titleStyle: .bodyStrong, valueStyle: .body)
        confirmationButton.setTitle(viewModel.buttonTitle, for: .normal)

        let fallbackImage: UIImage = UIImage(named: .noImage)
        if let logoImageUrl = viewModel.logoImageUrl {
            logoImageView.loadImage(for: logoImageUrl, imageWidth: logoImageWidth, fallbackImage: fallbackImage)
        } else {
            logoImageView.setImage(fallbackImage, animated: false)
        }
    }
}
