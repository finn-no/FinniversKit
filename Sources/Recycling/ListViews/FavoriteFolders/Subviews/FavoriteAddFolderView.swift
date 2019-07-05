//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteAddFolderView: UIView {
    static let imageWidth: CGFloat = 40
    private static let shadowRadius: CGFloat = 2

    var isTopShadowHidden: Bool = false {
        didSet {
            layer.shadowRadius = isTopShadowHidden ? 0 : FavoriteAddFolderView.shadowRadius
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.backgroundColor = UIColor(r: 246, g: 248, b: 251)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .center
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .bodyStrong
        label.textColor = .primaryBlue
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = CGRect(x: 0, y: -layer.shadowRadius, width: bounds.width, height: layer.shadowRadius)
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }

    // MARK: - Setup

    func configure(withTitle title: String) {
        imageView.image = UIImage(named: .favoritesPlus)
        titleLabel.text = title
    }

    private func setup() {
        backgroundColor = .milk
        isAccessibilityElement = true

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = FavoriteAddFolderView.shadowRadius
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor

        addSubview(imageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: FavoriteAddFolderView.imageWidth),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
