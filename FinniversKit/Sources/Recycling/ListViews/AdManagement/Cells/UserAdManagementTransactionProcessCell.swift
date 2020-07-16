//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol UserAdManagementMotorTransactionCellDelegate: AnyObject {
    func userAdManagementMotorTransactionCellDidTapSummary(_ view: UserAdManagementMotorTransactionCell)
    func userAdManagementMotorTransactionCellDidTapExternalView(_ view: UserAdManagementMotorTransactionCell)
}

public class UserAdManagementMotorTransactionCell: UITableViewCell {
    // MARK: - Public

    public var delegate: UserAdManagementMotorTransactionCellDelegate?

    // MARK: - Private

    private lazy var transactionSummaryView = MotorTransactionSummaryAdManagementView(withAutoLayout: true)

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

    public func configure(with viewModel: MotorTransactionSummaryViewModel, shouldShowExternalView shouldShow: Bool) {
        transactionSummaryView.configure(with: viewModel, shouldShowExternalView: shouldShow)
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .bgPrimary
        selectionStyle = .none

        addSubview(transactionSummaryView)
        transactionSummaryView.fillInSuperview()
        transactionSummaryView.delegate = self
    }
}

extension UserAdManagementMotorTransactionCell: MotorTransactionSummaryAdManagementViewDelegate {
    public func motorTransactionSummaryViewWasTapped(_ view: MotorTransactionSummaryAdManagementView) {
        delegate?.userAdManagementMotorTransactionCellDidTapSummary(self)
    }

    public func motorTransactionSummaryExternalViewWasTapped(_ view: MotorTransactionSummaryAdManagementView) {
        delegate?.userAdManagementMotorTransactionCellDidTapExternalView(self)
    }
}
