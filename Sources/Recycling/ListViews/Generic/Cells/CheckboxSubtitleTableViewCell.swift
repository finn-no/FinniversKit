//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol CheckboxSubtitleTableViewCellViewModel: CheckboxTableViewCellViewModel {
    var subtitle: String? { get }
}

public class CheckboxSubtitleTableViewCell: CheckboxTableViewCell {

    lazy var subtitleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.numberOfLines = 0
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        return stackView
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
    
    public func configure(with viewModel: CheckboxSubtitleTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        checkbox.isHighlighted = viewModel.isSelected
        separatorInset = .leadingInset(56)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
