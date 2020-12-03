import FinniversKit

public protocol MotorTransactionInsuranceViewModel {
    var logoImage: UIImage { get }
    var companyName: String { get }
    var bodyTexts: [String] { get }
    var accessibilityLabel: String { get }
}

protocol MotorTransactionInsuranceViewDelegate: AnyObject {
    func motorTransactionInsuranceViewWasSelected(_ view: MotorTransactionInsuranceView)
}

class MotorTransactionInsuranceView: UIView {
    private lazy var containerView = SelectableView(withSubview: stackView, withAutoLayout: true)
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
    private lazy var logoImageView = RoundedImageView(withAutoLayout: true)
    private lazy var companyNameLabel = Label(style: .bodyStrong, withAutoLayout: true)

    weak var delegate: MotorTransactionInsuranceViewDelegate?

    // MARK: - Init

    init(viewModel: MotorTransactionInsuranceViewModel, withAutoLayout: Bool = false) {
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
            logoImageView.widthAnchor.constraint(equalToConstant: 30),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
    }

    private func configure(with viewModel: MotorTransactionInsuranceViewModel) {
        companyNameLabel.text = viewModel.companyName
        logoImageView.image = viewModel.logoImage

        containerView.setAccessibilityLabel(viewModel.accessibilityLabel)

        for text in viewModel.bodyTexts {
            let label = Label(style: .detail, withAutoLayout: true)
            label.text = text
            label.numberOfLines = 0
            stackView.addArrangedSubview(label)
        }
    }
}

// MARK: - SelectableViewDelegate

extension MotorTransactionInsuranceView: SelectableViewDelegate {
    func selectableViewWasTapped(_ selectableView: SelectableView) {
        delegate?.motorTransactionInsuranceViewWasSelected(self)
    }
}
