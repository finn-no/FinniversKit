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
        stackView.isLayoutMarginsRelativeArrangement = true

        if #available(iOS 11.0, *) {
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
                top: .mediumLargeSpacing, leading: 0, bottom: 0, trailing: 0
            )
        } else {
            stackView.layoutMargins = UIEdgeInsets(top: .mediumLargeSpacing, left: 0, bottom: 0, right: 0)
        }

        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
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

    // MARK: - Setup

    func configure(withContent content: Content, rows: [Row]) {
        titleLabel.text = content.title
        linkButton.setTitle(content.link?.title, for: .normal)
        linkButtonUrl = content.link?.url
        iconImageView.image = content.icon

        for oldSubview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(oldSubview)
            oldSubview.removeFromSuperview()
        }

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

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            linkButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .mediumLargeSpacing),
            linkButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            linkButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            iconImageView.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: .smallSpacing),
            iconImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: NeighborhoodProfileInfoViewCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
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

    static func height(forContent content: Content, rows: [Row], width: CGFloat) -> CGFloat {
        let width = width - .mediumLargeSpacing * 2
        var height = CGFloat.mediumLargeSpacing

        // Title label
        height += content.title.height(withConstrainedWidth: width, font: titleFont)

        // Stack view
        if !rows.isEmpty {
            height += InfoRowView.height * CGFloat(rows.count) + .mediumLargeSpacing
        }

        // Link button
        if let link = content.link {
            height += link.title.height(withConstrainedWidth: width, font: linkButtonFont)
        }

        // Icon image view
        if content.icon != nil {
            height += iconSize + .smallSpacing
        }

        height += .mediumLargeSpacing

        return height
    }
}

// MARK: - Private types

private final class InfoRowView: UIView {
    static let height: CGFloat = 18

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

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            detailTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            iconImageView.trailingAnchor.constraint(equalTo: detailTextLabel.leadingAnchor, constant: -.mediumSpacing),
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: InfoRowView.height),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
        ])
    }

    private func makeLabel() -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .stone
        return label
    }
}
