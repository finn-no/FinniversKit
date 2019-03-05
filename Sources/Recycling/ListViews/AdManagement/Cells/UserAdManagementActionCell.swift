//
//  Copyright © FINN.no AS. All rights reserved.
//

public class UserAdManagementActionCell: UITableViewCell {
    public weak var delegate: UserAdManagementActionCellDelegate?
    public private(set) var actionType: AdManagementActionType = .unknown

    private var shouldShowExternalIcon: Bool = false

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
        let toggle = UISwitch(frame: .zero)
        toggle.addTarget(self, action: #selector(toggleTapped(_:)), for: .touchUpInside)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private lazy var externalAction: UIImageView = {
        let icon = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        var imageView = UIImageView(image: icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .stone
        return imageView
    }()

    private var chevronConstraints = [NSLayoutConstraint]()
    private var toggleConstraints = [NSLayoutConstraint]() // TODO: Naming, toggle is also a verb
    private var externalActionConstraints = [NSLayoutConstraint]()
    private var descriptionLabelConstraints = [NSLayoutConstraint]()
    private var descriptionToChevronTrailingConstraint = NSLayoutConstraint()
    private var descriptionToExternalTrailingConstraint = NSLayoutConstraint()
    private var descriptionToContentTrailingConstraint = NSLayoutConstraint()
    private var descriptionToToggleTrailingConstraint = NSLayoutConstraint()
    private var titleLabelCenterYToContentViewConstraint = NSLayoutConstraint()
    private var contentViewBottomToTitleConstraint = NSLayoutConstraint()
    private var contentViewBottomToDescriptionConstraint = NSLayoutConstraint()
    private var titleLabelHeightConstraint = NSLayoutConstraint()
    private var descriptionLabelHeightConstraint = NSLayoutConstraint()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let text = titleLabel.text else { return }
        let width = titleLabel.frame.width
        let height = text.height(withConstrainedWidth: width, font: titleLabel.font)
        titleLabelHeightConstraint.constant = height
        if contentView.subviews.contains(descriptionLabel) {
            guard let text = descriptionLabel.text else { return }
            let width = descriptionLabel.frame.width
            let height = text.height(withConstrainedWidth: width, font: descriptionLabel.font)
            descriptionLabelHeightConstraint.constant = height
        }
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
            contentView.addSubview(externalAction)
            NSLayoutConstraint.activate(externalActionConstraints)
        } else if model.shouldShowChevron {
            contentView.addSubview(chevronView)
            NSLayoutConstraint.activate(chevronConstraints)
        } else if model.shouldShowSwitch {
            contentView.addSubview(toggle)
            NSLayoutConstraint.activate(toggleConstraints)
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

    // MARK: - Constraints

    // MARK: - Private functions

    private func setup() {
        contentView.addSubview(separator)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)

        let hairLineSize = 1.0/UIScreen.main.scale

        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        let titleLabelTopConstraint = titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 16)
        titleLabelTopConstraint.priority = .defaultLow

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 24),
            separator.topAnchor.constraint(equalTo: contentView.topAnchor),
            separator.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: hairLineSize),
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: separator.leadingAnchor),
            titleLabelTopConstraint,
            titleLabelHeightConstraint,
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 0),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
            ])

        // The chevron is smaller than elsewhere, but this is by design. I guess we'll disuss this
        // while iterating, prior to release, ¯\_(ツ)_/¯
        chevronConstraints = [ chevronView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                               chevronView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                               chevronView.widthAnchor.constraint(equalToConstant: 10),
                               chevronView.heightAnchor.constraint(equalToConstant: 10),
                               titleLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -8)
        ]
        toggleConstraints = [ toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                              toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                              titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: toggle.leadingAnchor, constant: -8)
        ]
        externalActionConstraints = [ externalAction.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                                      externalAction.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                      externalAction.widthAnchor.constraint(equalToConstant: 20),
                                      externalAction.heightAnchor.constraint(equalToConstant: 20),
                                      titleLabel.trailingAnchor.constraint(equalTo: externalAction.leadingAnchor, constant: -8)
        ]
        descriptionLabelHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        descriptionLabelConstraints = [ descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                                        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
                                        descriptionLabelHeightConstraint
        ]
        descriptionToChevronTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -8)
        descriptionToExternalTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: externalAction.leadingAnchor, constant: -8)
        descriptionToContentTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        descriptionToToggleTrailingConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -8)
        titleLabelCenterYToContentViewConstraint = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        contentViewBottomToTitleConstraint = contentView.bottomAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 16)
        contentViewBottomToTitleConstraint.priority = .defaultHigh
        contentViewBottomToDescriptionConstraint = contentView.bottomAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.bottomAnchor, constant: 16)
        contentViewBottomToDescriptionConstraint.priority = .defaultHigh
    }

    private func cleanup() {
        toggle.removeFromSuperview()
        descriptionLabel.removeFromSuperview()
        chevronView.removeFromSuperview()
        externalAction.removeFromSuperview()

        NSLayoutConstraint.deactivate(chevronConstraints)
        NSLayoutConstraint.deactivate(toggleConstraints)
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

public protocol UserAdManagementActionCellDelegate: class {
    func userAdManagementActionCell(_ cell: UserAdManagementActionCell, switchChangedState switchIsOn: Bool)
}
