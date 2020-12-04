import FinniversKit

public protocol MotorTransactionInsurancePickerViewModel {
    var title: String { get }
    var bodyText: String { get }
    var insurances: [MotorTransactionInsuranceViewModel] { get }
}

public protocol MotorTransactionInsurancePickerViewDelegate: AnyObject {
    func motorTransactionInsurancePickerView(_ view: MotorTransactionInsurancePickerView, didSelectInsuranceAtIndex index: Int)
}

public class MotorTransactionInsurancePickerView: ShadowScrollView {

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

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.delegate = self
        return scrollView
    }()

    private weak var delegate: MotorTransactionInsurancePickerViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    // MARK: - Init

    public init(
        viewModel: MotorTransactionInsurancePickerViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource,
        delegate: MotorTransactionInsurancePickerViewDelegate,
        withAutoLayout: Bool = false
    ) {
        self.remoteImageViewDataSource = remoteImageViewDataSource
        self.delegate = delegate
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
        insertSubview(scrollView, belowSubview: topShadowView)
        scrollView.fillInSuperview()

        let contentView = UIView(withAutoLayout: true)
        scrollView.addSubview(contentView)
        contentView.fillInSuperview()

        contentView.addSubview(stackView)
        stackView.fillInSuperview(margin: .spacingM)

        stackView.addArrangedSubviews([titleLabel, bodyLabel])
        stackView.setCustomSpacing(.spacingS, after: titleLabel)
        stackView.setCustomSpacing(.spacingXL, after: bodyLabel)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
            topShadowView.bottomAnchor.constraint(equalTo: topAnchor),
        ])
    }

    private func configure(with viewModel: MotorTransactionInsurancePickerViewModel) {
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.bodyText

        for insurance in viewModel.insurances {
            let view = MotorTransactionInsuranceView(
                viewModel: insurance,
                remoteImageViewDataSource: remoteImageViewDataSource,
                delegate: self,
                withAutoLayout: true
            )
            stackView.addArrangedSubview(view)
        }
    }
}

// MARK: - MotorTransactionInsuranceViewDelegate

extension MotorTransactionInsurancePickerView: MotorTransactionInsuranceViewDelegate {
    func motorTransactionInsuranceViewWasSelected(_ view: MotorTransactionInsuranceView) {
        guard let index = stackView
            .arrangedSubviews
            .filter({ $0 is MotorTransactionInsuranceView })
            .firstIndex(of: view)
        else { return }

        delegate?.motorTransactionInsurancePickerView(self, didSelectInsuranceAtIndex: index)
    }
}
