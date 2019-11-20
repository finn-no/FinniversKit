//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Bootstrap

open class HeartTableViewCell: BasicTableViewCell {

    // MARK: - Public properties

    open var heartView: AnimatedHeartView = {
        let heartView = AnimatedHeartView(frame: .zero)
        heartView.translatesAutoresizingMaskIntoConstraints = false
        return heartView
    }()

    // MARK: - Private properties

    private lazy var stackViewToHeartConstraint = stackView.leadingAnchor.constraint(equalTo: heartView.trailingAnchor)

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
        heartView.isHighlighted = viewModel.isSelected

        if viewModel.subtitle != nil {
            stackViewToHeartConstraint.constant = .mediumLargeSpacing
            separatorInset = .leadingInset(60)
        } else {
            stackViewToHeartConstraint.constant = .mediumSpacing
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
        stackViewLeadingAnchorConstraint.isActive = false
        NSLayoutConstraint.activate([
            stackViewToHeartConstraint,
            heartView.heightAnchor.constraint(equalToConstant: 28),
            heartView.widthAnchor.constraint(equalTo: heartView.heightAnchor),
            heartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            heartView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
