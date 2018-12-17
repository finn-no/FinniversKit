//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BannerTransparencyViewDelegate: AnyObject {
    func bannerTransparencyViewDidSelectAdSettingsButton(_ view: BannerTransparencyView)
    func bannerTransparencyViewDidSelectReadMoreButton(_ view: BannerTransparencyView)
}

public final class BannerTransparencyView: UIView {
    public weak var delegate: BannerTransparencyViewDelegate?
    private lazy var scrollView = UIScrollView(withAutoLayout: true)
    private lazy var contentView = UIView(withAutoLayout: true)

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: FinniversImageAsset.finnLogo)
        return imageView
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = .licorice
        return label
    }()

    private lazy var adSettingsSection = BannerTransparencySectionView(withAutoLayout: true)
    private lazy var readMoreSection = BannerTransparencySectionView(withAutoLayout: true)

    public var model: BannerTransparencyViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            headerLabel.text = model.headerText
            adSettingsSection.set(title: model.adsSettingsTitle, text: model.adsSettingsText, buttonTitle: model.adsSettingsButtonTitle)
            readMoreSection.set(title: model.readMoreTitle, text: model.readMoreText, buttonTitle: model.readMoreButtonTitle)
        }
    }

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
        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(logoImageView)
        contentView.addSubview(headerLabel)
        contentView.addSubview(adSettingsSection)
        contentView.addSubview(readMoreSection)

        scrollView.fillInSuperview()

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            logoImageView.widthAnchor.constraint(equalToConstant: 77),
            logoImageView.heightAnchor.constraint(equalToConstant: 27),

            headerLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: .mediumSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            headerLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),

            adSettingsSection.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .mediumLargeSpacing),
            adSettingsSection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            adSettingsSection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            readMoreSection.topAnchor.constraint(equalTo: adSettingsSection.bottomAnchor),
            readMoreSection.leadingAnchor.constraint(equalTo: adSettingsSection.leadingAnchor),
            readMoreSection.trailingAnchor.constraint(equalTo: adSettingsSection.trailingAnchor),
            readMoreSection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing)
        ])
    }
}

// MARK: - BannerTransparencySectionViewDelegate

extension BannerTransparencyView: BannerTransparencySectionViewDelegate {
    func bannerTransparencySectionViewDidSelectExternalLinkButton(_ view: BannerTransparencySectionView) {
        if view === adSettingsSection {
            delegate?.bannerTransparencyViewDidSelectAdSettingsButton(self)
        } else if view == readMoreSection {
            delegate?.bannerTransparencyViewDidSelectReadMoreButton(self)
        }
    }
}
