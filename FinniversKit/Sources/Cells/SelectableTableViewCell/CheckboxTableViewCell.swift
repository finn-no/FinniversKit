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

    open var onCheckboxTap: (() -> Void)? {
        didSet {
            checkboxButton.isUserInteractionEnabled = onCheckboxTap != nil
        }
    }

    // MARK: - Private properties

    private lazy var stackViewToCheckboxConstraint = stackView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor)

    private lazy var checkboxButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        button.accessibilityElementsHidden = true
        return button
    }()

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
        onCheckboxTap = nil
    }

    // MARK: - Private methods

    @objc private func checkboxButtonTapped() {
        onCheckboxTap?()
    }

    private func setup() {
        contentView.addSubview(checkbox)
        contentView.addSubview(checkboxButton)
        stackViewLeadingAnchorConstraint.isActive = false

        NSLayoutConstraint.activate([
            stackViewToCheckboxConstraint,
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Warp.Spacing.spacing200),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            checkboxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            checkboxButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            checkboxButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            checkboxButton.trailingAnchor.constraint(equalTo: stackView.leadingAnchor),
        ])
    }
}
