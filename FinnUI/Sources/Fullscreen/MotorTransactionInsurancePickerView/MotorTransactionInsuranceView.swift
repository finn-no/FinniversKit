import FinniversKit

public protocol MotorTransactionInsuranceViewModel {
    var logoImageUrl: String? { get }
    var companyName: String { get }
    var bodyTexts: [String] { get }
    var accessibilityLabel: String { get }
}

protocol MotorTransactionInsuranceViewDelegate: AnyObject {
    func motorTransactionInsuranceViewWasSelected(_ view: MotorTransactionInsuranceView)
}

class MotorTransactionInsuranceView: UIView {
    private lazy var containerView = NavigationLinkView(withSubview: stackView, withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
    private lazy var companyNameLabel = Label(style: .bodyStrong, withAutoLayout: true)
    private let logoImageWidth: CGFloat = 30

    private lazy var logoImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.dataSource = remoteImageViewDataSource
        imageView.layer.cornerRadius = logoImageWidth/2
        imageView.clipsToBounds = true
        return imageView
    }()

    private weak var delegate: MotorTransactionInsuranceViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    // MARK: - Init

    init(
        viewModel: MotorTransactionInsuranceViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource?,
        delegate: MotorTransactionInsuranceViewDelegate,
        withAutoLayout: Bool = false
    ) {
        self.remoteImageViewDataSource = remoteImageViewDataSource
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
        configure(with: viewModel)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(containerView)
        containerView.fillInSuperview()
        containerView.delegate = self

        let companyStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        companyStackView.addArrangedSubviews([logoImageView, companyNameLabel])
        logoImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.addArrangedSubview(companyStackView)

        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: logoImageWidth),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
    }

    private func configure(with viewModel: MotorTransactionInsuranceViewModel) {
        companyNameLabel.text = viewModel.companyName

        containerView.setAccessibilityLabel(viewModel.accessibilityLabel)

        for text in viewModel.bodyTexts {
            let label = Label(style: .detail, withAutoLayout: true)
            label.text = text
            label.numberOfLines = 0
            stackView.addArrangedSubview(label)
        }

        let fallbackImage: UIImage = UIImage(named: .noImage)
        if let logoImageUrl = viewModel.logoImageUrl {
            logoImageView.loadImage(for: logoImageUrl, imageWidth: logoImageWidth, fallbackImage: fallbackImage)
        } else {
            logoImageView.setImage(fallbackImage, animated: false)
        }
    }
}

// MARK: - NavigationLinkViewDelegate

extension MotorTransactionInsuranceView: NavigationLinkViewDelegate {
    func navigationLinkViewWasTapped(_ navigationLinkView: NavigationLinkView) {
        delegate?.motorTransactionInsuranceViewWasSelected(self)
    }
}
