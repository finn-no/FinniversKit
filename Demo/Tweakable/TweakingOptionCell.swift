import FinniversKit

class TweakingOptionCell: UITableViewCell {
    var option: TweakingOption? {
        didSet {
            titleLabel.text = option?.title
            descriptionLabel.text = option?.description
        }
    }

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

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumSpacing),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing)
            ])
    }
}
