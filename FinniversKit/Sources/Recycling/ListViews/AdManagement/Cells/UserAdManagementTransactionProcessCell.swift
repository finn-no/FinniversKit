//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol UserAdManagementTransactionProcessCellDelegate: AnyObject {
    func userAdManagementTransactionProcessCellDidTapSummary(_ view: UserAdManagementTransactionProcessCell)
    func userAdManagementTransactionProcessCellDidTapExternalView(_ view: UserAdManagementTransactionProcessCell)
}

public class UserAdManagementTransactionProcessCell: UITableViewCell {
    // MARK: - Public

    public var delegate: UserAdManagementTransactionProcessCellDelegate?

    // MARK: - Private

    private lazy var transactionProcessSummaryView = TransactionProcessSummaryAdManagementView(withAutoLayout: true)

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

    public func configure(with viewModel: TransactionProcessSummaryViewModel, shouldShowExternalView shouldShow: Bool) {
        transactionProcessSummaryView.configure(with: viewModel, shouldShowExternalView: shouldShow)
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

extension UserAdManagementTransactionProcessCell: TransactionProcessSummaryAdManagementViewDelegate {
    public func transactionProcessSummaryViewWasTapped(_ view: TransactionProcessSummaryAdManagementView) {
        delegate?.userAdManagementTransactionProcessCellDidTapSummary(self)
    }

    public func transactionProcessExternalViewWasTapped(_ view: TransactionProcessSummaryAdManagementView) {
        delegate?.userAdManagementTransactionProcessCellDidTapExternalView(self)
    }
}
