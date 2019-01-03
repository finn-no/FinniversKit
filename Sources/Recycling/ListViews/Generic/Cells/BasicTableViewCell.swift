//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

open class BasicTableViewCell: UITableViewCell {

    // MARK: - Public properties

    open lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .licorice
        return label
    }()

    open lazy var subtitleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    open lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, handleLayoutInSubclass: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        if !handleLayoutInSubclass {
            setup()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    open func configure(with viewModel: BasicTableViewCellViewModel) {
        titleLabel.text = viewModel.title

        if let subtitle = viewModel.subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }

        if viewModel.hasChevron {
            accessoryType = .disclosureIndicator
            selectionStyle = .default
        } else {
            accessoryType = .none
            selectionStyle = .none
        }

        separatorInset = .leadingInset(.mediumLargeSpacing)
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    // MARK: - Private methods

    private func setup() {
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13),
        ])
    }
}
