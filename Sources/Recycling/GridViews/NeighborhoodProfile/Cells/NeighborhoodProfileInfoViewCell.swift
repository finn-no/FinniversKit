//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol NeighborhoodProfileInfoViewCellDelegate: AnyObject {
    func neighborhoodProfileInfoViewCellDidSelectLinkButton(_ view: NeighborhoodProfileInfoViewCell)
}

final class NeighborhoodProfileInfoViewCell: NeighborhoodProfileViewCell {
    typealias Content = NeighborhoodProfileViewModel.Content
    typealias Row = NeighborhoodProfileViewModel.Row

    weak var delegate: NeighborhoodProfileInfoViewCellDelegate?
    private(set) var linkButtonUrl: URL?

    private lazy var titleLabel: UILabel = makeTitleLabel()

    private lazy var linkButton: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = NeighborhoodProfileInfoViewCell.linkButtonFont
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleLinkButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .smallSpacing
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var stackViewTopConstraint: NSLayoutConstraint = {
        return stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing)
    }()

    private lazy var linkButtonToStackViewConstraint: NSLayoutConstraint = {
        return linkButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .mediumSpacing)
    }()

    private lazy var linkButtonToTitleLabelConstraint: NSLayoutConstraint = {
        return linkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing)
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        linkButton.setTitle(nil, for: .normal)
        linkButtonUrl = nil
        iconImageView.image = nil
        stackView.removeArrangedSubviews()
    }

    // MARK: - Setup

    func configure(withContent content: Content, rows: [Row]) {
        setNeedsLayout()
        layoutIfNeeded()

        titleLabel.text = content.title

        linkButton.setTitle(content.link?.title, for: .normal)
        linkButtonUrl = content.link?.url
        linkButtonToStackViewConstraint.isActive = !rows.isEmpty
        linkButtonToTitleLabelConstraint.isActive = rows.isEmpty

        iconImageView.image = rows.count <= NeighborhoodProfileInfoViewCell.maxRowsWithIcon ? content.icon : nil

        stackView.removeArrangedSubviews()
        stackView.isHidden = rows.isEmpty
        stackViewTopConstraint.constant = rows.isEmpty ? 0 : .mediumLargeSpacing

        for row in rows {
            let rowView = InfoRowView()
            rowView.configure(withTitle: row.title, detailText: row.detailText, icon: row.icon)
            stackView.addArrangedSubview(rowView)
        }
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(stackView)
        addSubview(linkButton)
        addSubview(iconImageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            stackViewTopConstraint,
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            linkButtonToStackViewConstraint,
            linkButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            linkButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            iconImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: NeighborhoodProfileInfoViewCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing)
        ])
    }

    // MARK: - Actions

    @objc private func handleLinkButtonTap() {
        delegate?.neighborhoodProfileInfoViewCellDidSelectLinkButton(self)
    }
}

// MARK: - Static

extension NeighborhoodProfileInfoViewCell {
    private static let linkButtonFont = UIFont.captionStrong
    private static let iconSize: CGFloat = 54
    private static let maxRowsWithIcon = 3

    static func height(forContent content: Content, rows: [Row], width: CGFloat) -> CGFloat {
        let width = width - .mediumLargeSpacing * 2
        var height = CGFloat.mediumLargeSpacing

        // Title label
        height += content.title.height(withConstrainedWidth: width, font: titleFont)

        // Stack view
        if !rows.isEmpty {
            height += InfoRowView.height() * CGFloat(rows.count) + .largeSpacing
        }

        // Link button
        if let link = content.link {
            height += link.title.height(withConstrainedWidth: width, font: linkButtonFont) + .mediumSpacing
        }

        // Icon image view
        if content.icon != nil && rows.count <= maxRowsWithIcon {
            height += iconSize
        }

        height += .mediumLargeSpacing

        return height
    }
}

// MARK: - Private types

private final class InfoRowView: UIView {
    private static let labelFont = UIFont.caption

    static func height() -> CGFloat {
        return "T".height(withConstrainedWidth: .mediumSpacing, font: labelFont)
    }

    private lazy var titleLabel: UILabel = makeLabel()
    private lazy var detailTextLabel = makeLabel()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .stone
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func configure(withTitle title: String, detailText: String?, icon: UIImage?) {
        titleLabel.text = title
        detailTextLabel.text = detailText
        iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(detailTextLabel)

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant: -.smallSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            detailTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            iconImageView.trailingAnchor.constraint(equalTo: detailTextLabel.leadingAnchor, constant: -.smallSpacing),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
        ])
    }

    private func makeLabel() -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.font = InfoRowView.labelFont
        label.textColor = .stone
        return label
    }
}

// MARK: - Private extensions

private extension UIStackView {
    func removeArrangedSubviews() {
        for oldSubview in arrangedSubviews {
            removeArrangedSubview(oldSubview)
            oldSubview.removeFromSuperview()
        }
    }
}
