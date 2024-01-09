//
//  Copyright © FINN.no AS. All rights reserved.
//
import UIKit

public protocol UserAdManagementActionCellDelegate: AnyObject {
    func userAdManagementActionCell(_ cell: UserAdManagementUserActionCell, switchChangedState switchIsOn: Bool)
}

public class UserAdManagementUserActionCell: UITableViewCell {

    // MARK: - Public properties

    public weak var delegate: UserAdManagementActionCellDelegate?

    // MARK: - Private properties

    private lazy var contentStackViewTrailingConstraint = contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)

    private lazy var separator: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .textDisabled
        return view
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingM, withAutoLayout: true)
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .iconPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.numberOfLines = 0
        label.font = .bodyStrong
        label.textColor = .textPrimary
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var trailingImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textSecondary
        return imageView
    }()

    private lazy var toggle: UISwitch = {
        let toggle = UISwitch(withAutoLayout: true)
        toggle.onTintColor = .nmpBrandControlSelected
        toggle.addTarget(self, action: #selector(toggleTapped(_:)), for: .touchUpInside)
        toggle.setContentHuggingPriority(.required, for: .horizontal)
        return toggle
    }()

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        contentStackView.addArrangedSubviews([iconImageView, titleLabel, trailingImageView, toggle])

        contentView.addSubview(separator)
        contentView.addSubview(contentStackView)

        trailingImageView.isHidden = true
        toggle.isHidden = true

        let hairLineSize = 1.0 / UIScreen.main.scale
        let iconImageWidthAndHeight: CGFloat = 24

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: (.spacingM * 2) + iconImageWidthAndHeight),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: hairLineSize),

            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStackViewTrailingConstraint,
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM),

            iconImageView.widthAnchor.constraint(equalToConstant: iconImageWidthAndHeight),
            iconImageView.heightAnchor.constraint(equalToConstant: iconImageWidthAndHeight),

            trailingImageView.widthAnchor.constraint(equalToConstant: 16),
            trailingImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    // MARK: - Public methods

    public func configure(with model: AdManagementActionCellModel) {
        titleLabel.text = model.title
        iconImageView.image = model.iconImage.withRenderingMode(.alwaysTemplate)

        switch model.trailingItem {
        case .none:
            break
        case .chevron:
            trailingImageView.image = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
            trailingImageView.isHidden = false
        case .external:
            trailingImageView.image = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
            trailingImageView.isHidden = false
            contentStackViewTrailingConstraint.constant = -.spacingL
        case .toggle:
            toggle.isHidden = false
        }

        setNeedsUpdateConstraints()
    }

    public func showSeparator(_ show: Bool) {
        separator.isHidden = !show
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()

        contentStackViewTrailingConstraint.constant = 0
        trailingImageView.isHidden = true
        toggle.isHidden = true
    }

    // MARK: - Actions

    @objc private func toggleTapped(_ sender: UISwitch) {
        delegate?.userAdManagementActionCell(self, switchChangedState: sender.isOn)
    }
}
