//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol BannerTransparencySectionViewDelegate: AnyObject {
    func bannerTransparencySectionViewDidSelectExternalLinkButton(_ view: BannerTransparencySectionView)
}

final class BannerTransparencySectionView: UIView {
    weak var delegate: BannerTransparencySectionViewDelegate?

    private lazy var headerLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailTextLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .caption
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }()

    private lazy var externalLinkButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = .zero
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .webview)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var model: BannerTransparencySectionViewModel? {
        didSet {
            guard let model = model else {
                return
            }

            headerLabel.text = model.headerText
            detailTextLabel.attributedText = model.detailText.attributedStringWithLineSpacing(4)
            externalLinkButton.setTitle(model.buttonTitle, for: .normal)
        }
    }

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

    private func setup() {
        addSubview(headerLabel)
        addSubview(detailTextLabel)
        addSubview(externalLinkButton)
        addSubview(externalLinkImageView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            detailTextLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .smallSpacing),
            detailTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            externalLinkButton.topAnchor.constraint(equalTo: detailTextLabel.bottomAnchor, constant: .smallSpacing),
            externalLinkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            externalLinkButton.trailingAnchor.constraint(equalTo: externalLinkImageView.leadingAnchor, constant: -.mediumLargeSpacing),

            externalLinkImageView.centerYAnchor.constraint(equalTo: externalLinkButton.centerYAnchor),
            externalLinkImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            externalLinkImageView.widthAnchor.constraint(equalToConstant: 18),
            externalLinkImageView.heightAnchor.constraint(equalTo: externalLinkImageView.widthAnchor),

            externalLinkButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.smallSpacing)
        ])
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.bannerTransparencySectionViewDidSelectExternalLinkButton(self)
    }
}
