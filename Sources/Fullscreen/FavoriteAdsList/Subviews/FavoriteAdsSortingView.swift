//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class FavoriteAdsSortingView: UIView {

    // MARK: - Internal properties

    var title: String = "" {
        didSet { sortingLabel.text = title.uppercased() }
    }

    // MARK: - Private properties

    private lazy var sortingLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detailStrong
        label.textColor = .textPrimary
        return label
    }()

    private lazy var arrowImage: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .iconPrimary
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
        addSubview(sortingLabel)
        addSubview(arrowImage)

        NSLayoutConstraint.activate([
            sortingLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            sortingLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sortingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),

            arrowImage.leadingAnchor.constraint(equalTo: sortingLabel.trailingAnchor, constant: 1),
            arrowImage.heightAnchor.constraint(equalToConstant: 12),
            arrowImage.widthAnchor.constraint(equalToConstant: 12),
            arrowImage.centerYAnchor.constraint(equalTo: sortingLabel.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
