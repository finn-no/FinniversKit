//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol CheckboxTableViewCellViewModel: BasicTableViewCellViewModel {
    var isSelected: Bool { get }
}

public class CheckboxTableViewCell: BasicTableViewCell {

    lazy var checkbox: AnimatedCheckboxImageView = {
        let checkbox = AnimatedCheckboxImageView(frame: .zero)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()

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

    public func configure(with viewModel: CheckboxTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        checkbox.isHighlighted = viewModel.isSelected
        separatorInset = .leadingInset(48)
    }

    public func animateSelection(isSelected: Bool) {
        checkbox.animateCheckbox(selected: isSelected)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
