import Foundation

public protocol TransactionEntrySlideViewDelegate: AnyObject {
    func transactionEntrySlideViewDidTapButton(_ transactionEntrySlideView: TransactionEntrySlideView)
}

public class TransactionEntrySlideView: UIView {
    private lazy var transactionEntryView = TransactionEntryView(delegate: self, remoteImageViewDataSource: remoteImageViewDataSource, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private weak var transactionEntryViewDelegate: TransactionEntryViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?

    public init(
        title: String,
        transactionEntryViewModel: TransactionEntryViewModel,
        transactionEntryViewDelegate: TransactionEntryViewDelegate?,
        remoteImageViewDataSource: RemoteImageViewDataSource?
    ) {
        super.init(frame: .zero)
        self.remoteImageViewDataSource = remoteImageViewDataSource

        titleLabel.text = title
        transactionEntryView.configure(with: transactionEntryViewModel)

        setup()
    }

    public init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(transactionEntryView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            transactionEntryView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            transactionEntryView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM),
            transactionEntryView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            transactionEntryView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension TransactionEntrySlideView: TransactionEntryViewDelegate {

}
