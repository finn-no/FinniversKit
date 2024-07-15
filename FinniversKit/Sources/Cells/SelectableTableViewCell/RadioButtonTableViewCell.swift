//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Warp

open class RadioButtonTableViewCell: BasicTableViewCell {

    lazy private var radioButton: RadioButtonView = {
        let radioButton = RadioButtonView()
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()

    public func configure(isSelected: Bool) {
        radioButton.configure(isSelected: isSelected)
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(radioButton)
        stackViewLeadingAnchorConstraint.isActive = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: Warp.Spacing.spacing200),
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

    open func configure(with viewModel: SelectableTableViewCellViewModel) {
        super.configure(with: viewModel)
        separatorInset = .leadingInset(56)
        radioButton.isHighlighted = viewModel.isSelected
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        radioButton.isHighlighted = false
    }
}
