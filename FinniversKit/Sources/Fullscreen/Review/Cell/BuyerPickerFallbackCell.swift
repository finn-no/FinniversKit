//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class BuyerPickerFallbackCell: UITableViewCell {
    static let cellhHeight: CGFloat = 60

    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    private lazy var hairlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .border
        return view
    }()

    private lazy var chevronLabel = Label(style: .detail, withAutoLayout: true)

    var model: BuyerPickerProfileModel? {
        didSet {
            titleLabel.text = model?.name
            chevronLabel.text = model?.chevronText
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    private func setup() {
        accessoryType = .disclosureIndicator
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingL),
            titleLabel.centerXAnchor.constraint(equalTo: accessoryView?.centerXAnchor ?? contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: accessoryView?.centerYAnchor ?? contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: BuyerPickerFallbackCell.cellhHeight),

            chevronLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            chevronLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingS),

            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: BuyerPickerFallbackCell.cellhHeight)
        ])
    }
}
