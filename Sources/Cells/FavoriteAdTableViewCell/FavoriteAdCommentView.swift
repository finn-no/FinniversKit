//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteAdCommentView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .favoritesComment)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var label: UILabel = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .licorice
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
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

    func configure(withText text: String) {
        label.text = text
    }

    private func setup() {
        addSubview(imageView)
        addSubview(label)

        directionalLayoutMargins = .init(all: .mediumSpacing)

        let margins = layoutMarginsGuide

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: margins.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 14),

            label.topAnchor.constraint(equalTo: margins.topAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumSpacing),
            label.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
}
