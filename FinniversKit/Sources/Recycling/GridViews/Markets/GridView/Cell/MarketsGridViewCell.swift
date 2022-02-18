//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class MarketsGridViewCell: UICollectionViewCell {
    // MARK: - Internal properties

    private let cornerRadius: CGFloat = 16

    private lazy var sharpShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .clear
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.applyShadow(ofType: .sharp)
        return view
    }()

    private lazy var smoothShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .clear
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.applyShadow(ofType: .smooth)
        return view
    }()

    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tileBackgroundColor
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        return view
    }()

    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .externalLinkColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label: Label
        if isHorizontalSizeClassRegular {
            label = Label(style: .caption)
        } else {
            label = Label(style: .detail)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    // MARK: - Setup

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .clear

        addSubview(sharpShadowView)
        addSubview(smoothShadowView)
        addSubview(containerView)
        containerView.addSubview(externalLinkImageView)
        containerView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews([iconImageView, titleLabel])

        sharpShadowView.fillInSuperview()
        smoothShadowView.fillInSuperview()
        containerView.fillInSuperview()

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            iconImageView.widthAnchor.constraint(equalToConstant: 42),

            contentStackView.widthAnchor.constraint(equalTo: widthAnchor),
            contentStackView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            externalLinkImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            externalLinkImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            externalLinkImageView.widthAnchor.constraint(equalToConstant: 12),
            externalLinkImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    // MARK: - Superclass Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        styleShadowAfterLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = ""
        accessibilityLabel = ""
    }

    // MARK: - Dependency injection

    var model: MarketsViewModel? {
        didSet {
            iconImageView.image = model?.iconImage
            titleLabel.text = model?.title
            accessibilityLabel = model?.accessibilityLabel

            let showExternalLinkIcon = model?.showExternalLinkIcon ?? false
            externalLinkImageView.isHidden = !showExternalLinkIcon
        }
    }
}

// MARK: - Private functions
private extension MarketsGridViewCell {
    func styleShadowAfterLayout() {
        self.smoothShadowView.layer.shadowPath = CGPath(
            roundedRect: self.smoothShadowView.bounds,
            cornerWidth: self.smoothShadowView.layer.cornerRadius,
            cornerHeight: self.smoothShadowView.layer.cornerRadius,
            transform: nil
        )
        self.sharpShadowView.layer.shadowPath = CGPath(
            roundedRect: self.sharpShadowView.bounds,
            cornerWidth: self.sharpShadowView.layer.cornerRadius,
            cornerHeight: self.sharpShadowView.layer.cornerRadius,
            transform: nil
        )
    }
}

private extension CALayer {

    enum ShadowType {
        case sharp
        case smooth
    }

    func applyShadow(ofType type: ShadowType) {
        self.masksToBounds = false

        switch type {
        case .sharp:
            self.shadowOpacity = 0.25
            self.shadowOffset = CGSize(width: 0, height: 1)
            self.shadowColor = UIColor.tileSharpShadowColor.cgColor
            self.shadowRadius = 1
        case .smooth:
            self.shadowOpacity = 0.16
            self.shadowOffset = CGSize(width: 0, height: 1)
            self.shadowColor = UIColor.tileSmoothShadowColor.cgColor
            self.shadowRadius = 5
        }
    }
}

// TODO: - These colors should be added to the ColorProvider at some point
private extension UIColor {
    class var externalLinkColor: UIColor {
        return .blueGray400
    }

    class var tileSharpShadowColor: UIColor {
        return .blueGray600
    }

    class var tileSmoothShadowColor: UIColor {
        return .blueGray600
    }

    class var tileBackgroundColor: UIColor {
        return .dynamicColor(defaultColor: .milk, darkModeColor: .blueGray700)
    }
}
