//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class MarketsGridViewCell: UICollectionViewCell {
    // MARK: - Internal properties
    
    private let cornerRadius: CGFloat = 16
    private let shadowColor = Config.colorProvider.tileShadow.cgColor
    
    private lazy var smallShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.applyShadow(ofType: .small)
        return view
    }()
    
    private lazy var bigShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.layer.applyShadow(ofType: .big)
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Config.colorProvider.tileBackgroundColor
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let sv = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        return sv
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
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

        addSubview(smallShadowView)
        addSubview(bigShadowView)
        addSubview(containerView)
        containerView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews([iconImageView, titleLabel])
        
        bigShadowView.fillInSuperview()
        smallShadowView.fillInSuperview()
        containerView.fillInSuperview()

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            iconImageView.widthAnchor.constraint(equalToConstant: 42),
            
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor),
            contentStackView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
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
        }
    }
}

// MARK: - Private functions
private extension MarketsGridViewCell {
    func styleShadowAfterLayout() {
        self.bigShadowView.layer.shadowPath = CGPath(
            roundedRect: self.bigShadowView.bounds,
            cornerWidth: self.bigShadowView.layer.cornerRadius,
            cornerHeight: self.bigShadowView.layer.cornerRadius,
            transform: nil
        )
        self.smallShadowView.layer.shadowPath = CGPath(
            roundedRect: self.smallShadowView.bounds,
            cornerWidth: self.smallShadowView.layer.cornerRadius,
            cornerHeight: self.smallShadowView.layer.cornerRadius,
            transform: nil
        )
    }
}

private extension CALayer {
    
    enum ShadowType {
        case small
        case big
    }
    
    func applyShadow(ofType type: ShadowType) {
        self.masksToBounds = false
        self.shadowColor = shadowColor
        
        switch type {
        case .small:
            self.shadowOpacity = 0.05
            self.shadowOffset = CGSize(width: 0, height: -1)
            self.shadowRadius = 1
        case .big:
            self.shadowOpacity = 0.14
            self.shadowOffset = CGSize(width: 0, height: 4)
            self.shadowRadius = 14
        }
    }
}
