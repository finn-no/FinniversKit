//
//  Copyright © FINN.no AS. All rights reserved.
//

public protocol UserAdManagementTransactionJourneyStatusCellDelegate: AnyObject {
    func transactionJourneyStatusCellWasTapped(_ view: UserAdManagementTransactionJourneyStatusCell)
}

public class UserAdManagementTransactionJourneyStatusCell: UserAdManagementUserActionCell {

    public weak var transactionJourneydelegate: UserAdManagementTransactionJourneyStatusCellDelegate?

    public var transactionJourneyStatusURL: String?

    private lazy var contentViewTapRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(didTapContentView)
    )

    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public func configure(title: String, iconImage: UIImage) {
        super.configure(with: AdManagementActionCellModel(title: title, iconImage: iconImage))

        showSeparator(false)
        contentView.addGestureRecognizer(contentViewTapRecognizer)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        transactionJourneyStatusURL = nil
    }

    @objc private func didTapContentView() {
        transactionJourneydelegate?.transactionJourneyStatusCellWasTapped(self)
    }
}
