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

    // MARK: - Internal properties

    weak var delegate: NeighborhoodProfileInfoViewCellDelegate?
    private(set) var linkButtonUrl: URL?

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingXS, alignment: .fill, distribution: .fillEqually, withAutoLayout: true)
    private lazy var stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingM)
    private lazy var linkButtonToStackViewConstraint = linkButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .spacingS)
    private lazy var linkButtonToTitleLabelConstraint = linkButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS)

    private lazy var linkButton: Button = {
        let button = Button(style: .link, withAutoLayout: true)
        button.titleLabel?.font = NeighborhoodProfileInfoViewCell.linkButtonFont
        button.titleLabel?.numberOfLines = 0
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleLinkButtonTap), for: .touchUpInside)
        return button
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
        stackViewTopConstraint.constant = rows.isEmpty ? 0 : .spacingM

        let rowViews = rows.map(InfoRowView.init(row:))
        stackView.addArrangedSubviews(rowViews)
    }

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(linkButton)
        contentView.addSubview(iconImageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            stackViewTopConstraint,
            stackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            linkButtonToStackViewConstraint,
            linkButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            linkButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            iconImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: NeighborhoodProfileInfoViewCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM)
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
        let width = width - .spacingM * 2
        var height = CGFloat.spacingM

        // Title label
        height += content.title.height(withConstrainedWidth: width, font: titleFont)

        // Stack view
        if !rows.isEmpty {
            height += InfoRowView.height() * CGFloat(rows.count) + .spacingXL
        }

        // Link button
        if let link = content.link {
            height += link.title.height(withConstrainedWidth: width, font: linkButtonFont) + .spacingS
        }

        // Icon image view
        if content.icon != nil && rows.count <= maxRowsWithIcon {
            height += iconSize
        }

        height += .spacingM

        return height
    }
}

// MARK: - Private types

private final class InfoRowView: UIView {
    private static let labelFont = UIFont.caption

    static func height() -> CGFloat {
        return "T".height(withConstrainedWidth: .spacingS, font: labelFont)
    }

    private lazy var titleLabel: UILabel = makeLabel()
    private lazy var detailTextLabel = makeLabel()
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .textSecondary
        return imageView
    }()

    init(row: NeighborhoodProfileViewModel.Row) {
        super.init(frame: .zero)
        setup()
        configure(with: row)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func configure(with row: NeighborhoodProfileViewModel.Row) {
        titleLabel.text = row.title
        detailTextLabel.text = row.detailText
        iconImageView.image = row.icon?.withRenderingMode(.alwaysTemplate)

        accessibilityLabel = row.accessibilityLabel ?? [row.title, row.detailText].compactMap { $0 }.joined(separator: ". ")
    }

    private func setup() {
        isAccessibilityElement = true
        accessibilityTraits = .staticText

        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(detailTextLabel)

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: iconImageView.leadingAnchor, constant: -.spacingXS),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            detailTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            iconImageView.trailingAnchor.constraint(equalTo: detailTextLabel.leadingAnchor, constant: -.spacingXS),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
        ])
    }

    private func makeLabel() -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.font = InfoRowView.labelFont
        label.textColor = .textSecondary
        return label
    }
}
