//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - View

final class FavoriteAddFolderView: UIView {
    static let imageWidth: CGFloat = 40

    var isTopShadowHidden: Bool {
        get { return shadowView.isHidden }
        set { shadowView.isHidden = newValue }
    }

    private lazy var shadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.masksToBounds = false
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 3
        //view.layer.shadowOffset = CGSize(width: 0, height: -10)
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor.black.cgColor
        return view
    }()

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

    // MARK: - Setup

    func configure(withTitle title: String) {
        imageView.image = UIImage(named: .favoritesPlus)
        titleLabel.text = title
    }

    private func setup() {
        clipsToBounds = false
        isAccessibilityElement = true
        backgroundColor = .milk

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(shadowView)

        shadowView.backgroundColor = .white

        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: 1),

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

// MARK: - Cell

final class FavoriteAddFolderViewCell: UITableViewCell {
    private lazy var addFolderView = FavoriteAddFolderView(withAutoLayout: true)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addFolderView.isTopShadowHidden = true
        contentView.addSubview(addFolderView)
        addFolderView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withTitle title: String) {
        addFolderView.configure(withTitle: title)
    }
}
