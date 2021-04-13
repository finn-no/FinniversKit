import Foundation

public protocol TransactionEntrySlideViewDelegate: AnyObject {
    func transactionEntrySlideViewDidTapButton(_ transactionEntrySlideView: TransactionEntrySlideView)
}

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

    private lazy var containerView = UIView(withAutoLayout: true)

    public init(
        title: String,
        transactionEntryViewModel: TransactionEntryViewModel,
        transactionEntryViewDelegate: TransactionEntryViewDelegate?,
        remoteImageViewDataSource: RemoteImageViewDataSource?
    ) {
        super.init(frame: .zero)
        titleLabel.text = title
        transactionEntryView.remoteImageViewDataSource = remoteImageViewDataSource
        transactionEntryView.configure(with: transactionEntryViewModel)
        transactionEntryView.delegate = transactionEntryViewDelegate
        setup()
    }

    public init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        transactionEntryView.widthAnchor.constraint(greaterThanOrEqualTo: containerView.widthAnchor, multiplier: 0.5),
        transactionEntryView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),
        transactionEntryView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        transactionEntryView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .spacingM),
        transactionEntryView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.spacingM),
    ]

    private func setup() {
        addSubview(containerView)

        containerView.addSubview(titleLabel)
        containerView.addSubview(transactionEntryView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .spacingM),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.spacingM),

            transactionEntryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            transactionEntryView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        setSizeClassConstraints()
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
