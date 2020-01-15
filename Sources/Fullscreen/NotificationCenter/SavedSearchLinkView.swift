//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public protocol SavedSearchLinkViewModel {
    var savedSearchText: String { get }
    var savedSearchTitle: String { get }
}

class SavedSearchLinkView: UIView {

    private lazy var iconView: UIImageView = {
        let image = UIImage(named: .search)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .licorice
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel = Label(
        style: .detail,
        withAutoLayout: true
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: SavedSearchLinkViewModel?) {
        titleLabel.text = model?.savedSearchText
    }

    private func setup() {
        addSubview(iconView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 10),
            iconView.heightAnchor.constraint(equalToConstant: 10),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: .smallSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
