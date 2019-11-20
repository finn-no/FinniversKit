//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Bootstrap

open class RadioButtonTableViewCell: BasicTableViewCell {

    lazy private var radioButton: AnimatedRadioButtonView = {
        let radioButton = AnimatedRadioButtonView(frame: .zero)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()

    public func animateSelection(isSelected: Bool) {
        radioButton.animateSelection(selected: isSelected)
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
            stackView.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: .mediumLargeSpacing),
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

    open func configure(with viewModel: SelectableTableViewCellViewModel) {
        super.configure(with: viewModel)
        separatorInset = .leadingInset(56)
        radioButton.animateSelection(selected: viewModel.isSelected)
    }
}
