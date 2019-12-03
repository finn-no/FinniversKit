//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class MinFinnProfileCell: UITableViewCell {

    private lazy var profileImageView = UIImageView(
        withAutoLayout: true
    )

    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var badgeImageView: UIImageView = {
        let image = UIImage(named: .verified)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var roundedView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.cornerRadius = 8
        view.backgroundColor = .bgSecondary
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }

    func configure(with model: MinFinnProfileCellModel?) {
        profileImageView.image = model?.image ?? UIImage(named: .avatar)
        titleLabel.text = model?.title
        subtitleLabel.text = model?.subtitle
        badgeImageView.isHidden = model?.showBadge == false
    }
}

private extension MinFinnProfileCell {
    func setup() {
        backgroundColor = .clear

        contentView.addSubview(roundedView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(badgeImageView)

        roundedView.fillInSuperview(
            insets: UIEdgeInsets(top: 0, left: .mediumLargeSpacing, bottom: 0, right: -.mediumLargeSpacing)
        )

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: .mediumLargeSpacing),
            profileImageView.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: roundedView.topAnchor, constant: .mediumLargeSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: .mediumSpacing),

            badgeImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .smallSpacing),
            badgeImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            badgeImageView.trailingAnchor.constraint(lessThanOrEqualTo: roundedView.trailingAnchor, constant: -.mediumLargeSpacing),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .verySmallSpacing),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: roundedView.trailingAnchor, constant: -.mediumLargeSpacing),

            roundedView.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
        ])
    }
}
