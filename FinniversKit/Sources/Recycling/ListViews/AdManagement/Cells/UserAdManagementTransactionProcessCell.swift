//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol UserAdManagementTransactionProcessCellDelegate: AnyObject {
    func userAdManagementTransactionProcessCellDidTapSummary(_ view: UserAdManagementTransactionProcessCell)
    func userAdManagementTransactionProcessCellDidTapExternalView(_ view: UserAdManagementTransactionProcessCell)
}

// swiftlint:disable:next type_name
public class UserAdManagementTransactionProcessCell: UITableViewCell {
    // MARK: - Public

    public var delegate: UserAdManagementTransactionProcessCellDelegate?

    // MARK: - Private

    private var model: TransactionProcessSummaryViewModel?
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
        transactionProcessSummaryView.delegate = self
    }
}

extension UserAdManagementTransactionProcessCell: TransactionProcessSummaryViewDelegate {
    public func transactionProcessSummaryViewWasTapped(_ view: TransactionProcessSummaryView) {
        delegate?.userAdManagementTransactionProcessCellDidTapSummary(self)
    }

    public func transactionProcessExternalViewWasTapped(_ view: TransactionProcessSummaryView) {
        delegate?.userAdManagementTransactionProcessCellDidTapExternalView(self)
    }
}
