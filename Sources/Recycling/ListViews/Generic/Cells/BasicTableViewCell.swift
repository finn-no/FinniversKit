//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BasicTableViewCellViewModel {
    var title: String { get }
}

open class BasicTableViewCell: UITableViewCell {

    // MARK: - Public properties

    open lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .licorice
        return label
    }()

    // MARK: - Setup

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, layoutInSubclass: Bool) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        if !layoutInSubclass {
            setup()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    open func configure(with viewModel: BasicTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        separatorInset = .leadingInset(.mediumLargeSpacing)
    }

    // MARK: - Private methods

    private func setup() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
            ])
    }
}
