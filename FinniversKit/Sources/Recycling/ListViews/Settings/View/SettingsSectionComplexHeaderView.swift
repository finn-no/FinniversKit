//
//  Copyright © 2023 FINN AS. All rights reserved.
//

import UIKit

class SettingsSectionComplexHeaderView: UITableViewHeaderFooterView {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, textColor: .textSubtle, withAutoLayout: true)
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .caption, numberOfLines: 2, textColor: .textSubtle, withAutoLayout: true)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with title: String?, subtitle: String?, image: UIImage) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = image
    }

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -.spacingS),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageView.leadingAnchor, constant: -.spacingS),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM)
        ])
    }
}
