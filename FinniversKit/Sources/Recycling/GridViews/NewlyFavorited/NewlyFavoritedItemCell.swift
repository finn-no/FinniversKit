//
//  NewlyFavoritedItemCell.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 11/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public class NewlyFavoritedItemCell: UICollectionViewCell {
    static let identifier = "NewlyFavoritedItemCell"
    private static let titleHeight: CGFloat = 8
    private static let priceTagHeight: CGFloat = 30
    private var isHeightCalculated = false
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .red
        imageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = Label(style: .captionStrong)
        label.textColor = .textTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = "500 kr"
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var priceBackground: UIView = {
        let background = UIVisualEffectView(withAutoLayout: true)
        if #available(iOS 13.0, *) {
            background.effect = UIBlurEffect(style: .systemThinMaterialDark)
        } else {
            background.effect = nil
            background.backgroundColor = UIColor(hex: "#262626").withAlphaComponent(0.8)
        }
        background.alpha = 1.0
        background.layer.cornerRadius = NewlyFavoritedItemCell.priceTagHeight / 2
        background.clipsToBounds = true
        
        background.contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            background.heightAnchor.constraint(equalToConstant: NewlyFavoritedItemCell.priceTagHeight),
            priceLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 8),
            priceLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -8),
            priceLabel.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -4)
            
        ])
        
        return background
    }()
    
    
    
    private let smallShadowView: UIView = {
        let view = UIView(withAutoLayout: false)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 8
        view.dropShadow(color: UIColor(hex: "#475569"), opacity: 0.24, offset: CGSize(width: 0, height: 1), radius: 1)
        return view
    }()
    
    private let largeShadowView: UIView = {
        let view = UIView(withAutoLayout: false)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 8
        view.dropShadow(color: UIColor(hex: "#475569"), opacity: 0.16, offset: CGSize(width: 0, height: 5), radius: 5)
        return view
    }()

    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(largeShadowView)
        view.addSubview(smallShadowView)
        view.addSubview(imageView)
        view.addSubview(priceLabel)

        return view
    }()
        
    private lazy var favoriteButton: IconButton = {
        let button = IconButton(style: .favorite)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoriteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var ribbonView: RibbonView = RibbonView(withAutoLayout: true)
    
    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        let random = Int.random(in: 0...2)
        label.text = random % 2 == 0 ? "LØREN - Nydelig, påkostet familebolig til salgs" : "Stol - Som NY!"
        label.numberOfLines = 2
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textColor = .textSecondary
        label.text = "Oslo"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        stackView.addArrangedSubviews([ribbonView, subtitleLabel, titleLabel])
        stackView.setCustomSpacing(4, after: subtitleLabel)
        return stackView
    }()
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        isHeightCalculated = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    private func setup() {
        ribbonView.style = .sponsored
        ribbonView.title = "Betalt plassering"
        ribbonView.setContentCompressionResistancePriority(.required, for: .vertical)
        ribbonView.isHidden = Int.random(in: (1...3)) % 2 == 0
        contentView.addSubview(imageContainerView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(priceBackground)
        contentView.addSubview(verticalStack)
        
        imageContainerView.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            imageContainerView.heightAnchor.constraint(equalToConstant: 128),
            
            verticalStack.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            verticalStack.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 8),
            verticalStack.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            titleLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            priceBackground.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            priceBackground.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8),
            priceBackground.trailingAnchor.constraint(lessThanOrEqualTo: imageContainerView.trailingAnchor, constant: -8),
            ribbonView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
        
        largeShadowView.fillInSuperview()
        smallShadowView.fillInSuperview()
    }
    
    @objc private func favoriteButtonPressed() {
        favoriteButton.isToggled.toggle()
    }
    
    public override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !isHeightCalculated {
            setNeedsLayout()
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = 128 + 4
            newFrame.size.height = CGFloat(ceilf(Float(size.height)))
            print(newFrame.size)
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
        }
        
        
        return layoutAttributes
    }
}

// MARK: - public functions
public extension NewlyFavoritedItemCell {
    func configure(with model: NewlyFavorited) {
        
    }
}
