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

    private lazy var stackView = UIStackView(axis: .horizontal, spacing: 1, alignment: .center, withAutoLayout: true)

    private lazy var sortingLabel = Label(
        style: .detailStrong,
        numberOfLines: 0,
        withAutoLayout: true
    )

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

        stackView.addArrangedSubviews([sortingLabel, arrowImage])
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing100),

            arrowImage.heightAnchor.constraint(equalToConstant: 12),
            arrowImage.widthAnchor.constraint(equalToConstant: 12),
        ])
    }
}
