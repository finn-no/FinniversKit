//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

open class HeartTableViewCell: BasicTableViewCell {

    // MARK: - Public properties

    open var heartView: AnimatedHeartView = {
        let heartView = AnimatedHeartView(frame: .zero)
        heartView.translatesAutoresizingMaskIntoConstraints = false
        return heartView
    }()

    // MARK: - Private properties

    private lazy var stackViewLeadingConstraint: NSLayoutConstraint = stackView.leadingAnchor.constraint(equalTo: heartView.trailingAnchor)

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, handleLayoutInSubclass: true)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, handleLayoutInSubclass: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier, handleLayoutInSubclass: true)

        if !handleLayoutInSubclass {
            setup()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    open func configure(with viewModel: SelectableTableViewCellViewModel) {
        super.configure(with: viewModel)
        selectionStyle = .none
        heartView.isHighlighted = viewModel.isSelected

        if viewModel.subtitle != nil {
            stackViewLeadingConstraint.constant = .mediumLargeSpacing
            separatorInset = .leadingInset(60)
        } else {
            stackViewLeadingConstraint.constant = .mediumSpacing
            separatorInset = .leadingInset(52)
        }

        layoutIfNeeded()
    }

    open func animateSelection(isSelected: Bool) {
        heartView.animateSelection(selected: isSelected)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        heartView.isHighlighted = false
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(heartView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            heartView.heightAnchor.constraint(equalToConstant: 28),
            heartView.widthAnchor.constraint(equalTo: heartView.heightAnchor),
            heartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            heartView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackViewLeadingConstraint,
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
            ])
    }
}
