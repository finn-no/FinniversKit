//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

class FavoriteAdsSortingView: UIView {

    // MARK: - Internal properties

    var title: String = "" {
        didSet {
            sortingLabel.text = title.uppercased()
            accessibilityLabel = title
        }
    }

    // MARK: - Private properties

    private lazy var sortingLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .text
        return label
    }()

    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .icon
        imageView.image = UIImage(named: .arrowDown).withRenderingMode(.alwaysTemplate)
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        isAccessibilityElement = true
        accessibilityTraits = .button

        addSubview(sortingLabel)
        addSubview(arrowImage)

        NSLayoutConstraint.activate([
            sortingLabel.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
            sortingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing100),

            arrowImage.leadingAnchor.constraint(equalTo: sortingLabel.trailingAnchor, constant: 1),
            arrowImage.heightAnchor.constraint(equalToConstant: 12),
            arrowImage.widthAnchor.constraint(equalToConstant: 12),
            arrowImage.centerYAnchor.constraint(equalTo: sortingLabel.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200)
        ])
    }
}
