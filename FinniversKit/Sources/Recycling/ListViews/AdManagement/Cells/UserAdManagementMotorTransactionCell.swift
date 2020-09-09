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

    private lazy var transactionView: MotorTransactionEntryAdManagementView = {
        let view = MotorTransactionEntryAdManagementView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

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
        
        contentView.addSubview(transactionView)
        
        NSLayoutConstraint.activate([
            transactionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            transactionView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            transactionView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            transactionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
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
