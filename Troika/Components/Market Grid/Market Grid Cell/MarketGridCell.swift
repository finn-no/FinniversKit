//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class MarketGridCell: UICollectionViewCell {

    // MARK: - Internal properties

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: UILayoutConstraintAxis.vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(frameworkImageNamed: "webview")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style = .detail(.licorice)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(externalLinkImageView)
        backgroundColor = .clear
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = ""
        accessibilityLabel = ""
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            externalLinkImageView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            externalLinkImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
        ])
    }

    // MARK: - Dependency injection

    public var presentable: MarketGridPresentable? {
        didSet {
            iconImageView.image = presentable?.iconImage
            titleLabel.text = presentable?.title
            accessibilityLabel = presentable?.accessibilityLabel
            if let presentable = presentable, presentable.showExternalLinkIcon {
                externalLinkImageView.isHidden = false
            } else {
                externalLinkImageView.isHidden = true
            }
        }
    }
}
