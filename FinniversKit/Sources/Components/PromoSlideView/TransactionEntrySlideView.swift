import Foundation

public class TransactionEntrySlideView: UIView {
    private lazy var transactionEntryView = TransactionEntryView(
        backgroundColor: .bgPrimary,
        withAutoLayout: true
    )

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)
        stackView.distribution = .equalCentering
        return stackView
    }()

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        stackView.widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: 0.5),
        stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
    ]

    // MARK: - Init

    public init(
        title: String,
        transactionEntryViewModel: TransactionEntryViewModel,
        transactionEntryViewDelegate: TransactionEntryViewDelegate?,
        remoteImageViewDataSource: RemoteImageViewDataSource?
    ) {
        super.init(frame: .zero)
        titleLabel.text = title
        transactionEntryView.remoteImageViewDataSource = remoteImageViewDataSource
        transactionEntryView.delegate = transactionEntryViewDelegate
        transactionEntryView.configure(with: transactionEntryViewModel)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.addArrangedSubviews([titleLabel, transactionEntryView])

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        setSizeClassConstraints()

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        transactionEntryView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    }

    private func setSizeClassConstraints() {
        if isHorizontalSizeClassRegular {
            NSLayoutConstraint.deactivate(compactConstraints)
            NSLayoutConstraint.activate(regularConstraints)
        } else {
            NSLayoutConstraint.deactivate(regularConstraints)
            NSLayoutConstraint.activate(compactConstraints)
        }
    }

    // MARK: - Overrides

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            setSizeClassConstraints()
        }
    }
}
