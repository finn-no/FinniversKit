//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol CheckboxSubtitleTableViewCellViewModel: CheckboxTableViewCellViewModel {
    var subtitle: String? { get }
}

open class CheckboxSubtitleTableViewCell: CheckboxTableViewCell {

    // MARK: - Public properties

    open lazy var subtitleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    open lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        return stackView
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

    open func configure(with viewModel: CheckboxSubtitleTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        checkbox.isHighlighted = viewModel.isSelected
        separatorInset = UIEdgeInsets(top: 0, leading: 56, bottom: 0, trailing: 0)
    }

    // MARK: - Private methods


    private func setup() {
        selectionStyle = .none
        contentView.addSubview(checkbox)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            checkbox.heightAnchor.constraint(equalToConstant: 24),
            checkbox.widthAnchor.constraint(equalTo: checkbox.heightAnchor),
            checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            stackView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
            ])
    }
}
