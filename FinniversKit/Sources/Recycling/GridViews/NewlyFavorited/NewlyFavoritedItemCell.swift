//
//  NewlyFavoritedItemCell.swift
//  FinniversKit
//
//  Created by Suthananth Arulanantham on 11/08/2021.
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

private extension UIView {
    static func priceTagView(_ price: String, height: CGFloat) -> UIView {
        let background = UIVisualEffectView(withAutoLayout: true)
        if #available(iOS 13.0, *) {
            background.effect = UIBlurEffect(style: .systemThinMaterialDark)
        } else {
            background.effect = nil
            background.backgroundColor = UIColor(hex: "#262626").withAlphaComponent(0.8)
        }
        background.alpha = 1.0
        background.layer.cornerRadius = height / 2
        background.clipsToBounds = true
        
        let label = Label(style: .captionStrong)
        label.textColor = .textTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.text = price
        label.textAlignment = .center
        
        
        background.contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            background.heightAnchor.constraint(equalToConstant: height),
            label.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: background.topAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -8)
            
        ])
        
        return background
//
//        let label = Label(style: .captionStrong)
//        label.textColor = .textTertiary
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .clear
//        label.text = price
//
//        let imageView = UIImageView(withAutoLayout: true)
//        imageView.layer.masksToBounds = true
//        imageView.contentMode = .scaleAspectFit
//        imageView.tintColor = .iconTertiary
//
//        background.contentView.addSubview(imageView)
//        background.contentView.addSubview(label)
//
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 8),
//            imageView.heightAnchor.constraint(equalToConstant: 23),
//            imageView.widthAnchor.constraint(equalToConstant: 23),
//            imageView.centerYAnchor.constraint(equalTo: background.centerYAnchor),
//
//            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
//            label.centerYAnchor.constraint(equalTo: background.centerYAnchor),
//            background.heightAnchor.constraint(equalToConstant: height)
//        ])
//        background.layoutIfNeeded()
//        return background
    }
}

class NewlyFavoritedItemCell: UICollectionViewCell {
    static let identifier = "NewlyFavoritedItemCell"
    private static let titleHeight: CGFloat = 8
    private static let priceTagHeight: CGFloat = 35
    
    
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
    
    private lazy var priceLabel: UIView = {
        return UIView.priceTagView("500 000 000 kr", height: 26)
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
    
    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        let random = Int.random(in: 0...2)
        label.text = random % 2 == 0 ? "LØREN - Nydelig, påkostet familebolig til salgs" : "Stol - Som NY!"
        label.numberOfLines = 2
        label.textAlignment = .left
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
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.image = nil
//        imageDescriptionLabel.text = nil
//        titleLabel.text = nil
//        subtitleLabel.text = nil
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
        contentView.addSubview(imageContainerView)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(priceLabel)
        
        imageContainerView.setContentCompressionResistancePriority(.required, for: .vertical)
       // imageView.dropShadow(color: .shadowSmall, opacity: 0.24, offset: CGSize(width: 0, height: 1), radius: 1)
        NSLayoutConstraint.activate([
            imageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            imageContainerView.heightAnchor.constraint(equalToConstant: 128),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 8),
            subtitleLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            titleLabel.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8),
            
            favoriteButton.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -8),
            priceLabel.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 8),
            priceLabel.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -8),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageContainerView.trailingAnchor, constant: -8)
        ])
        
        largeShadowView.fillInSuperview()
        smallShadowView.fillInSuperview()
    }
    
    @objc private func favoriteButtonPressed() {
        favoriteButton.isToggled.toggle()
    }
}
