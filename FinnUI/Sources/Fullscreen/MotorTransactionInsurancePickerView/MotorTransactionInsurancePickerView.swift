import FinniversKit

public protocol MotorTransactionInsurancePickerViewModel {
    var title: String { get }
    var bodyText: String { get }
    var insurances: [MotorTransactionInsuranceViewModel] { get }
}

public protocol MotorTransactionInsurancePickerViewDelegate: AnyObject {
    func motorTransactionInsurancePickerView(_ view: MotorTransactionInsurancePickerView, didSelectInsuranceAtIndex index: Int)
}

public class MotorTransactionInsurancePickerView: UIView {

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    public weak var delegate: MotorTransactionInsurancePickerViewDelegate?

    public init(
        viewModel: MotorTransactionInsurancePickerViewModel,
        withAutoLayout: Bool = false
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
        configure(with: viewModel)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)
        addSubview(bodyLabel)
        addSubview(stackView)

        let padding: CGFloat = .spacingM

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),

            stackView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: .spacingXL),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    private func configure(with viewModel: MotorTransactionInsurancePickerViewModel) {
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.bodyText

        for insurance in viewModel.insurances {
            let view = MotorTransactionInsuranceView(viewModel: insurance, withAutoLayout: true)
            view.delegate = self
            stackView.addArrangedSubview(view)
        }
    }
}

// MARK: - MotorTransactionInsuranceViewDelegate

extension MotorTransactionInsurancePickerView: MotorTransactionInsuranceViewDelegate {
    func motorTransactionInsuranceViewWasSelected(_ view: MotorTransactionInsuranceView) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: view) else { return }
        delegate?.motorTransactionInsurancePickerView(self, didSelectInsuranceAtIndex: index)
    }
}
