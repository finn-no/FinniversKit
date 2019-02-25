//
//  Copyright © FINN.no AS. All rights reserved.
//

public class UserAdManagementActionCell: UITableViewCell {
    public weak var delegate: UserAdManagementActionCellDelegate?

    private lazy var separator: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .sardine
        return view
    }()

    private lazy var iconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .licorice
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.title4
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.detail
        label.textColor = .licorice
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var chevronView: UIImageView = { // arrowRight?
        var imageView = UIImageView(image: UIImage(named: .arrowRight))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .sardine
        return imageView
    }()

    private lazy var toggle: UISwitch = {
        let toggle = UISwitch(frame: .zero)
        toggle.addTarget(self, action: #selector(toggleTapped(_:)), for: .touchUpInside)
        toggle.setContentHuggingPriority(.required, for: .horizontal)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    public private(set) var actionType: AdManagementActionType = .unknown
    public func setupWithModel(_ model: AdManagementActionCellModel) {
        selectionStyle = .none
        if model.actionType != actionType {
            // This might force us to clear old stuff out of the way...
            toggle.removeFromSuperview()
            descriptionLabel.removeFromSuperview()
            chevronView.removeFromSuperview()
        }

        actionType = model.actionType
        titleLabel.text = model.title
        iconView.image = model.image

        contentView.addSubview(separator)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        model.shouldShowChevron ? contentView.addSubview(chevronView) : chevronView.removeFromSuperview()

        let hairLineSize = 1.0/UIScreen.main.scale

        var constraints: [NSLayoutConstraint] = [
            separator.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 24),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: hairLineSize),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: separator.leadingAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
        ]

        // Note, not all combination of model.properties are supported, as the Model will only allow
        // certain combinations, based on the ActionType

        if model.hasSwitch {
            // TODO: The type will infer what the toggle isOn status should be
            contentView.addSubview(toggle)

            constraints += [ toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                             toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                             titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -8),
                             titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor) ]
        } else if model.description != nil {
            descriptionLabel.text = model.description
            contentView.addSubview(descriptionLabel)
            constraints += [ descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                             descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0) ]
            if model.shouldShowChevron {
                constraints += [ descriptionLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: 8) ]
            } else {
                constraints += [ descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 16) ]
            }
        }

        if model.shouldShowChevron {
            contentView.addSubview(chevronView)
            constraints += [ chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                             chevronView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                             chevronView.widthAnchor.constraint(equalToConstant: 9),
                             chevronView.heightAnchor.constraint(equalToConstant: 16),
                             titleLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: 8) ]
        }
        if model.description == nil {
            constraints += [ titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                             contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 16) ]
        } else {
            constraints += [contentView.bottomAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 16)]
        }

        NSLayoutConstraint.activate(constraints)
    }

    public func showSeparator(_ show: Bool) {
        separator.isHidden = !show
    }

    // MARK: - Constraints

    // MARK: - Private functions

    @objc private func toggleTapped(_ sender: UISwitch) {
        delegate?.userAdManagementActionCell(self, switchChangedState: sender.isOn)
    }
}

public protocol UserAdManagementActionCellDelegate: class {
    func userAdManagementActionCell(_ cell: UserAdManagementActionCell, switchChangedState switchIsOn: Bool)
}
