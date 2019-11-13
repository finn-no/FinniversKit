import UIKit

open class BasicTableViewCell: UITableViewCell {

    // MARK: - Public properties

    open var selectedIndexPath: IndexPath?
    open var isEnabled: Bool = true

    open lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    open lazy var subtitleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    open lazy var detailLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detail
        label.textColor = .textSecondary
        return label
    }()

    open lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 2
        stackView.axis = .vertical
        return stackView
    }()

    open lazy var stackViewLeadingAnchorConstraint = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing)
    open lazy var stackViewTrailingAnchorConstraint = stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
    open lazy var stackViewBottomAnchorConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
    open lazy var stackViewTopAnchorConstraint = stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13)
    open lazy var detailLabelTrailingConstraint = detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

    // MARK: - Private properties

    private lazy var stackViewToDetailLabelConstraint = stackView.trailingAnchor.constraint(lessThanOrEqualTo: detailLabel.leadingAnchor, constant: -.smallSpacing)

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    open func configure(with viewModel: BasicTableViewCellViewModel, indexPath: IndexPath? = nil) {
        titleLabel.text = viewModel.title

        let isSelected = selectedIndexPath != nil ? selectedIndexPath == indexPath : false
        titleLabel.textColor = isSelected ? .textAction : .textPrimary

        titleLabel.isEnabled = isEnabled

        if let subtitle = viewModel.subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.isHidden = true
        }

        if let detailText = viewModel.detailText {
            detailLabel.text = detailText
            detailLabel.isHidden = false
            stackViewToDetailLabelConstraint.isActive = true
        } else {
            detailLabel.isHidden = true
            stackViewToDetailLabelConstraint.isActive = false
        }

        if viewModel.hasChevron {
            accessoryType = .disclosureIndicator
            selectionStyle = .default
            if #available(iOS 13.0, *) {
                detailLabelTrailingConstraint.constant = -.mediumSpacing
                stackViewTrailingAnchorConstraint.constant = -.mediumSpacing
            } else {
                detailLabelTrailingConstraint.constant = 0
                stackViewTrailingAnchorConstraint.constant = 0
            }
        } else {
            accessoryType = .none
            selectionStyle = .none
            detailLabelTrailingConstraint.constant = -.mediumLargeSpacing
            stackViewTrailingAnchorConstraint.constant = -.mediumLargeSpacing
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
        setDefaultSelectedBackgound()
        backgroundColor = .bgPrimary

        contentView.addSubview(stackView)
        contentView.addSubview(detailLabel)

        NSLayoutConstraint.activate([
            stackViewTopAnchorConstraint,
            stackViewLeadingAnchorConstraint,
            stackViewTrailingAnchorConstraint,
            stackViewBottomAnchorConstraint,

            detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            detailLabelTrailingConstraint
            ])
    }
}
