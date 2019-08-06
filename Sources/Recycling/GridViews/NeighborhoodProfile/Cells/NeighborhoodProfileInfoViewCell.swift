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

    private lazy var titleLabel: UILabel = makeTitleLabel()

    private lazy var linkButton: Button = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .captionStrong
        button.addTarget(self, action: #selector(handleLinkButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .smallSpacing
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var iconImageView = UIImageView(withAutoLayout: true)

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
        linkButton.setTitle(content.title, for: .normal)
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
            linkButton.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor, constant: -.mediumSpacing),

            iconImageView.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: .smallSpacing),
            iconImageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: .mediumLargeSpacing)
        ])
    }

    // MARK: - Actions

    @objc private func handleLinkButtonTap() {
        delegate?.neighborhoodProfileInfoViewCellDidSelectLinkButton(self)
    }
}

// MARK: - Private types

private final class InfoRowView: UIView {
    private lazy var titleLabel: UILabel = makeLabel()
    private lazy var detailTextLabel = makeLabel()
    private lazy var iconImageView = UIImageView(withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withTitle title: String, detailText: String?, icon: UIImage?) {
        titleLabel.text = title
        detailTextLabel.text = detailText
        iconImageView.image = icon
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
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func makeLabel() -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .stone
        return label
    }
}
