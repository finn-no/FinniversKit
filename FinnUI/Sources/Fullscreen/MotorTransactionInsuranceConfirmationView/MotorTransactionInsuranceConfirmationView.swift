import FinniversKit

public protocol MotorTransactionInsuranceConfirmationViewModel {
    var logoImageUrl: String? { get }
    var companyName: String { get }
}

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

        let margin: CGFloat = .spacingM

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            topShadowView.bottomAnchor.constraint(equalTo: topAnchor),

            companyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            companyStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            companyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),

            logoImageView.widthAnchor.constraint(equalToConstant: logoImageWidth),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),

        ])
    }

    private func configure(with viewModel: MotorTransactionInsuranceConfirmationViewModel) {
        companyNameLabel.text = viewModel.companyName

        let fallbackImage: UIImage = UIImage(named: .noImage)
        if let logoImageUrl = viewModel.logoImageUrl {
            logoImageView.loadImage(for: logoImageUrl, imageWidth: logoImageWidth, fallbackImage: fallbackImage)
        } else {
            logoImageView.setImage(fallbackImage, animated: false)
        }
    }
}
