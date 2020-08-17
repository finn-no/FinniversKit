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

    private lazy var transactionView = MotorTransactionEntryAdManagementView(withAutoLayout: true)

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

    public func configure(with viewModel: MotorTransactionEntryViewModel, shouldShowExternalView shouldShow: Bool) {
        transactionView.configure(with: viewModel, shouldShowExternalView: shouldShow)
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .bgPrimary
        selectionStyle = .none

        addSubview(transactionView)
        transactionView.fillInSuperview()
        transactionView.delegate = self
    }
}

extension UserAdManagementMotorTransactionCell: MotorTransactionEntryAdManagementViewDelegate {
    public func motorTransactionEntryViewWasTapped(_ view: MotorTransactionEntryAdManagementView) {
        delegate?.userAdManagementMotorTransactionCellDidTapSummary(self)
    }

    public func motorTransactionEntryExternalViewWasTapped(_ view: MotorTransactionEntryAdManagementView) {
        delegate?.userAdManagementMotorTransactionCellDidTapExternalView(self)
    }
}
