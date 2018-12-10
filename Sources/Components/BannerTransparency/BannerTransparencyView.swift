//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public final class BannerTransparencyView: UIScrollView {
    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var finnLogoImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: FinniversImageAsset.finnLogo)
        return imageView
    }()
    private lazy var finnHeaderLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .licorice
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contentView)

        contentView.addSubview(finnLogoImageView)
        contentView.addSubview(finnHeaderLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),

            finnLogoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            finnLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            finnLogoImageView.widthAnchor.constraint(equalToConstant: 77),
            finnLogoImageView.heightAnchor.constraint(equalToConstant: 27),

            finnHeaderLabel.leadingAnchor.constraint(equalTo: finnLogoImageView.trailingAnchor, constant: .mediumSpacing),
            finnHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            finnHeaderLabel.centerYAnchor.constraint(equalTo: finnLogoImageView.centerYAnchor)
        ])
    }
}
