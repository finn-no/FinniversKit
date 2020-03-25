//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public class UserAdManagementTransactionProcessSummaryCell: UITableViewCell {
    // MARK: - Public

    private var model: TransactionProcessSummaryViewModel?

    // MARK: - Private

    private lazy var transactionProcessSummaryView = TransactionProcessSummaryView(withAutoLayout: true)

    // MARK: - Initalization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods

    public func configure(with viewModel: TransactionProcessSummaryViewModel) {
        model = viewModel
        transactionProcessSummaryView.configure(with: viewModel)
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .bgPrimary
        selectionStyle = .none

        addSubview(transactionProcessSummaryView)
        transactionProcessSummaryView.fillInSuperview()
    }
}
