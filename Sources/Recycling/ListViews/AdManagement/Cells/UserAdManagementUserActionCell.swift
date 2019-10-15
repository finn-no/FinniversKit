//
//  Copyright © FINN.no AS. All rights reserved.
//

public class UserAdManagementUserActionCell: UITableViewCell {
    public weak var delegate: UserAdManagementActionCellDelegate?
    public private(set) var actionType: AdManagementActionType = .unknown

    private var shouldShowExternalIcon: Bool = false

    private lazy var separator: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .textDisabled
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
        label.font = UIFont.bodyStrong
        label.textColor = .licorice
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
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

    private lazy var chevronView: UIImageView = {
        let chevron = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        var imageView = UIImageView(image: chevron)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .stone
        return imageView
    }()

    private lazy var toggle: UISwitch = {
        let toggle = UISwitch(withAutoLayout: true)
        toggle.onTintColor = .btnPrimary
        toggle.addTarget(self, action: #selector(toggleTapped(_:)), for: .touchUpInside)
        return toggle
    }()

    private lazy var externalActionView: UIImageView = {
        let icon = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        var imageView = UIImageView(image: icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .stone
        return imageView
    }()

    // MARK: - Constraint properties

    private var chevronConstraints = [NSLayoutConstraint]()
    private var toggleControlConstraints = [NSLayoutConstraint]()
    private var externalActionConstraints = [NSLayoutConstraint]()
    private var descriptionLabelConstraints = [NSLayoutConstraint]()
    private var descriptionToChevronTrailingConstraint = NSLayoutConstraint()
    private var descriptionToExternalTrailingConstraint = NSLayoutConstraint()
    private var descriptionToContentTrailingConstraint = NSLayoutConstraint()
    private var descriptionToToggleTrailingConstraint = NSLayoutConstraint()
    private var titleLabelCenterYToContentViewConstraint = NSLayoutConstraint()
    private var contentViewBottomToTitleConstraint = NSLayoutConstraint()
    private var contentViewBottomToDescriptionConstraint = NSLayoutConstraint()

    // MARK: - Public

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setupWithModel(_ model: AdManagementActionCellModel) {
        titleLabel.text = model.title
        iconView.image = model.image
        descriptionLabel.text = model.description

        if model.actionType == actionType &&  model.shouldShowExternalIcon == shouldShowExternalIcon { return }
        actionType = model.actionType
        shouldShowExternalIcon = model.shouldShowExternalIcon
        cleanup()

        if model.shouldShowExternalIcon { // External icon overrides chevron, as host-app needs this functionality
            contentView.addSubview(externalActionView)
            NSLayoutConstraint.activate(externalActionConstraints)
        } else if model.shouldShowChevron {
            contentView.addSubview(chevronView)
            NSLayoutConstraint.activate(chevronConstraints)
        } else if model.shouldShowSwitch {
            contentView.addSubview(toggle)
            NSLayoutConstraint.activate(toggleControlConstraints)
        }

        if model.description != nil {
            contentView.addSubview(descriptionLabel)
            NSLayoutConstraint.activate(descriptionLabelConstraints)

            if model.shouldShowExternalIcon {
                descriptionToExternalTrailingConstraint.isActive = true
            } else if model.shouldShowChevron {
                descriptionToChevronTrailingConstraint.isActive = true
            } else if model.shouldShowSwitch {
                descriptionToToggleTrailingConstraint.isActive = true
            } else {
                descriptionToContentTrailingConstraint.isActive = true
            }
        }

        let noDescription = model.description == nil
        titleLabelCenterYToContentViewConstraint.isActive = noDescription
        let contentBottomConstraint = noDescription ? contentViewBottomToTitleConstraint : contentViewBottomToDescriptionConstraint
        contentBottomConstraint.isActive = true
        setNeedsUpdateConstraints()
    }

    public func showSeparator(_ show: Bool) {
        separator.isHidden = !show
    }

    // MARK: - Private functions

    private func setup() {
        contentView.addSubview(separator)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)

        let hairLineSize = 1.0/UIScreen.main.scale
        let missingMagicNumberSpacing: CGFloat = 24
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: .mediumLargeSpacing),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: hairLineSize),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: missingMagicNumberSpacing),
            iconView.heightAnchor.constraint(equalToConstant: missingMagicNumberSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: separator.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48)
            ])

        // The chevron is smaller than elsewhere, but this is by design. I guess we'll disuss this
        // while iterating, prior to release, ¯\_(ツ)_/¯
        let chevronSize: CGFloat = 16
        chevronConstraints = [ chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
                               chevronView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                               chevronView.widthAnchor.constraint(equalToConstant: chevronSize),
                               chevronView.heightAnchor.constraint(equalToConstant: chevronSize),
                               titleLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -.mediumSpacing)
        ]
        toggleControlConstraints = [ toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
                              toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                              titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -.mediumSpacing)
        ]
        let externalSize: CGFloat = 16
        externalActionConstraints = [ externalActionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                                      externalActionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                      externalActionView.widthAnchor.constraint(equalToConstant: externalSize),
                                      externalActionView.heightAnchor.constraint(equalToConstant: externalSize),
                                      titleLabel.trailingAnchor.constraint(equalTo: externalActionView.leadingAnchor, constant: -.mediumSpacing)
        ]
        descriptionLabelConstraints = [ descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                                        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
        ]
        descriptionToChevronTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -.mediumSpacing)
        descriptionToExternalTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: externalActionView.leadingAnchor, constant: -.mediumSpacing)
        descriptionToContentTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing)
        descriptionToToggleTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -.mediumSpacing)
        titleLabelCenterYToContentViewConstraint = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        contentViewBottomToTitleConstraint = contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing)
        contentViewBottomToDescriptionConstraint = contentView.bottomAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: .mediumLargeSpacing)
    }

    private func cleanup() {
        toggle.removeFromSuperview()
        descriptionLabel.removeFromSuperview()
        chevronView.removeFromSuperview()
        externalActionView.removeFromSuperview()

        NSLayoutConstraint.deactivate(chevronConstraints)
        NSLayoutConstraint.deactivate(toggleControlConstraints)
        NSLayoutConstraint.deactivate(externalActionConstraints)
        NSLayoutConstraint.deactivate(descriptionLabelConstraints)
        descriptionToChevronTrailingConstraint.isActive = false
        descriptionToExternalTrailingConstraint.isActive = false
        descriptionToContentTrailingConstraint.isActive = false
        descriptionToToggleTrailingConstraint.isActive = false
        titleLabelCenterYToContentViewConstraint.isActive = false
        contentViewBottomToDescriptionConstraint.isActive = false
        contentViewBottomToTitleConstraint.isActive = false
    }

    @objc private func toggleTapped(_ sender: UISwitch) {
        delegate?.userAdManagementActionCell(self, switchChangedState: sender.isOn)
    }
}

public protocol UserAdManagementActionCellDelegate: AnyObject {
    func userAdManagementActionCell(_ cell: UserAdManagementUserActionCell, switchChangedState switchIsOn: Bool)
}
