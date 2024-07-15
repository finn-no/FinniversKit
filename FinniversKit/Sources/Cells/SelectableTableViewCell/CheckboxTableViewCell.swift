//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

open class CheckboxTableViewCell: BasicTableViewCell {

    // MARK: - Public properties

    open var checkbox: CheckboxView = {
        let checkbox = CheckboxView()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()

    // MARK: - Private properties

    private lazy var stackViewToCheckboxConstraint = stackView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor)

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    open func configure(with viewModel: SelectableTableViewCellViewModel) {
        super.configure(with: viewModel)
        selectionStyle = .none
        checkbox.configure(isSelected: viewModel.isSelected)
        stackViewToCheckboxConstraint.constant = Warp.Spacing.spacing200
        separatorInset = .leadingInset(56)
        layoutIfNeeded()
    }

    open func configure(isSelected: Bool) {
        checkbox.configure(isSelected: isSelected)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        checkbox.isHighlighted = false
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(checkbox)
        stackViewLeadingAnchorConstraint.isActive = false

        NSLayoutConstraint.activate([
            stackViewToCheckboxConstraint,
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
