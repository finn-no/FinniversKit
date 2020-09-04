//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

class EmptyNotificationsCell: UITableViewCell {

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var emptyPersonalConstraints = [
        iconImageView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
        iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
        iconImageView.widthAnchor.constraint(equalToConstant: 80),
        iconImageView.heightAnchor.constraint(equalToConstant: 80),

        stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingM),
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
        stackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),

        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: iconImageView.bottomAnchor, constant: .spacingM),
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: .spacingM),
    ]

    private lazy var emptySavedSearchConstraints = [
        iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingXXL),
        iconImageView.widthAnchor.constraint(equalToConstant: 48),
        iconImageView.heightAnchor.constraint(equalToConstant: 48),

        stackView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: .spacingL),
        stackView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .spacingM),
        stackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: -.spacingL),

        contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .spacingM),
    ]

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: EmptyNotificationsCellModel?) {
        iconImageView.image = model?.icon
        titleLabel.text = model?.title
        bodyLabel.text = model?.body
        contentView.backgroundColor = .clear
        backgroundColor = .clear

        switch model?.kind {
        case .personal:
            iconImageView.layer.cornerRadius = 40
            stackView.alignment = .leading
            stackView.spacing = 0

            NSLayoutConstraint.deactivate(emptySavedSearchConstraints)
            NSLayoutConstraint.activate(emptyPersonalConstraints)
        case .savedSearch:
            iconImageView.layer.cornerRadius = 0
            stackView.alignment = .center
            stackView.spacing = .spacingL

            NSLayoutConstraint.deactivate(emptyPersonalConstraints)
            NSLayoutConstraint.activate(emptySavedSearchConstraints)
        case .none:
            NSLayoutConstraint.deactivate(emptyPersonalConstraints)
            NSLayoutConstraint.deactivate(emptySavedSearchConstraints)
        }
    }
}

private extension EmptyNotificationsCell {
    func setup() {
        selectionStyle = .none
        contentView.addSubview(iconImageView)
        contentView.addSubview(stackView)
    }
}
