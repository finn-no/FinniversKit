//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class MinFinnProfileCell: BasicTableViewCell {

    private lazy var profileImageView = UIImageView(
        withAutoLayout: true
    )

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
        super.configure(with: model)
        profileImageView.image = model?.image ?? UIImage(named: .avatar)
        badgeImageView.isHidden = model?.showBadge == false
    }
}

private extension MinFinnProfileCell {
    func setup() {
        backgroundColor = .clear
        subtitleLabel.font = .detail

        contentView.insertSubview(roundedView, belowSubview: stackView)
        contentView.addSubview(profileImageView)
        contentView.addSubview(badgeImageView)

        roundedView.fillInSuperview(
            insets: UIEdgeInsets(top: 0, left: .mediumLargeSpacing, bottom: 0, right: -.mediumLargeSpacing)
        )

        stackView.alignment = .leading
        stackViewLeadingAnchorConstraint.isActive = false
        stackViewTopAnchorConstraint.constant = .mediumLargeSpacing
        stackViewBottomAnchorConstraint.constant = -.mediumLargeSpacing

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: roundedView.leadingAnchor, constant: .mediumLargeSpacing),
            profileImageView.centerYAnchor.constraint(equalTo: roundedView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: .mediumSpacing),

            badgeImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: .smallSpacing),
            badgeImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            badgeImageView.trailingAnchor.constraint(lessThanOrEqualTo: roundedView.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
