//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public class UserAdManagementTransactionProcessCell: UITableViewCell {
    // MARK: - Public

    private var model: TransactionProcessViewModel?

    // MARK: - Private

    private lazy var transactionProcessView = TransactionProcessView(withAutoLayout: true)

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

    public func configure(with viewModel: TransactionProcessViewModel) {
        model = viewModel
        transactionProcessView.configure(with: viewModel)
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .bgPrimary
        selectionStyle = .none

        addSubview(transactionProcessView)
        transactionProcessView.fillInSuperview()
    }
}
