//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol CheckboxTableViewCellViewModel: BasicTableViewCellViewModel {
    var isSelected: Bool { get }
}

open class CheckboxTableViewCell: BasicTableViewCell {

    // MARK: - Public properties

    open var checkbox: AnimatedCheckboxView = {
        let checkbox = AnimatedCheckboxView(frame: .zero)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()

    // MARK: - Setup

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, layoutInSubclass: true)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, layoutInSubclass: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, layoutInSubclass: true)

        if !layoutInSubclass {
            setup()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    open func configure(with viewModel: CheckboxTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        checkbox.isHighlighted = viewModel.isSelected
        separatorInset = .leadingInset(48)
    }

    open func animateSelection(isSelected: Bool) {
        checkbox.animateSelection(selected: isSelected)
    }

    // MARK: - Private methods

    private func setup() {
        selectionStyle = .none
        contentView.addSubview(checkbox)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            checkbox.heightAnchor.constraint(equalToConstant: 24),
            checkbox.widthAnchor.constraint(equalTo: checkbox.heightAnchor),
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: .mediumSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
            ])
    }
}
