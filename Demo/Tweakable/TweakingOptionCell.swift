import FinniversKit

class TweakingOptionCell: UITableViewCell {
    private var descriptionLabelBottomAnchor: NSLayoutConstraint?

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func configure(withOption option: TweakingOption, isSelected: Bool, for traitCollection: UITraitCollection) {
        titleLabel.text = option.title
        descriptionLabel.text = option.description
        backgroundColor = .clear
        selectionStyle = .none

        if descriptionLabel.text == nil {
            descriptionLabelBottomAnchor?.isActive = false
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing).isActive = true
        }
        updateColors(for: traitCollection, isSelected: isSelected)
    }

    private func updateColors(for traitCollection: UITraitCollection, isSelected: Bool) {
        let cellTextColor: UIColor
        switch UserInterfaceStyle(traitCollection: traitCollection) {
        case .light:
            cellTextColor = isSelected ? .primaryBlue : .licorice
        case .dark:
            cellTextColor = isSelected ? .secondaryBlue : .milk
        }
        titleLabel.textColor = cellTextColor
        descriptionLabel.textColor = cellTextColor
    }
}

extension TweakingOptionCell {
    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            ])

        descriptionLabelBottomAnchor = descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing)
        descriptionLabelBottomAnchor?.isActive = true
    }
}
