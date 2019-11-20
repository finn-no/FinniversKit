//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Bootstrap

open class CheckboxTableViewCell: BasicTableViewCell {

    // MARK: - Public properties

    open var checkbox: AnimatedCheckboxView = {
        let checkbox = AnimatedCheckboxView(frame: .zero)
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
        checkbox.isHighlighted = viewModel.isSelected
        stackViewToCheckboxConstraint.constant = .mediumLargeSpacing
        separatorInset = .leadingInset(56)
        layoutIfNeeded()
    }

    open func animateSelection(isSelected: Bool) {
        checkbox.animateSelection(selected: isSelected)
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
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
