//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

final class FavoriteAdActionHeaderView: UIView {
    private lazy var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(
            style: Self.titleLabelStyle,
            numberOfLines: 0,
            withAutoLayout: true
        )
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .textDisabled
        return view
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

    func configure(withImage image: UIImage?, title: String) {
        imageView.image = image
        titleLabel.text = title
    }

    private func setup() {
        backgroundColor = .background
        addSubview(blurView)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(hairlineView)

        layoutMargins = FavoriteAdActionHeaderView.layoutMargins

        blurView.fillInSuperview()

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: FavoriteAdActionHeaderView.imageViewSize),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .titleLabelTopSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),

            hairlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .hairlineTopSpacing),
            hairlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: .hairlineHeight),
            hairlineView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}

// MARK: - Static

extension FavoriteAdActionHeaderView {
    private static let layoutMargins = UIEdgeInsets(
        top: Warp.Spacing.spacing100,
        left: Warp.Spacing.spacing200,
        bottom: 0,
        right: Warp.Spacing.spacing200
    )

    private static let imageViewSize: CGFloat = 56
    private static let titleLabelStyle = Warp.Typography.body

    static func height(forTitle title: String, width: CGFloat) -> CGFloat {
        let width = width - layoutMargins.left - layoutMargins.right
        var height = layoutMargins.top

        height += imageViewSize
        height += .titleLabelTopSpacing + title.height(withConstrainedWidth: width, font: titleLabelStyle.uiFont)
        height += .hairlineTopSpacing + .hairlineHeight
        height += layoutMargins.bottom

        return height
    }
}

// MARK: - Private extensions

private extension CGFloat {
    static let titleLabelTopSpacing: CGFloat = 10
    static let hairlineTopSpacing: CGFloat = 18
    static let hairlineHeight = 1 / UIScreen.main.scale
}
